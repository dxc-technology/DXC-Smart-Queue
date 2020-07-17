from django.test import TestCase

from random import randrange  # to simulate occupancy sensor and queue times
import random  # simulate the assignment of addresses
import unittest
import uuid  # unique IDs for queues
import arrow  # advanced date data types
from enum import Enum  # for reservation states

from smartqueue import SmartQueue, Resource, Reservation, Location, Queue, ReservationState, ReserveActionResult

# Create your tests here.

def dummy_sensor():
  return 0

def sim_occupancy_sensor():
  occupants = randrange(50)
  return occupants

def random_datetime():
  Year = '2020'
  Month = str(randrange(1,12)).zfill(2)
  Day = str(str(randrange(1,28)).zfill(2))
  Hour = str(randrange(23)).zfill(2)
  Minute = str(randrange(59)).zfill(2)

  Date = Year +'-' + Month + '-' + Day + ' ' + Hour + ':' + Minute
  return arrow.get(Date, 'YYYY-MM-DD HH:mm')

def queue(address, destination, resource_id):
  QUEUE_SPAN_IN_MINS = 10
  id = uuid.uuid1().hex
  start = random_datetime()
  end = start.shift(minutes=+QUEUE_SPAN_IN_MINS)
  max = 10
  return {'queue_id':id, 'start_datetime':start, 'end_datetime':end, 'max_capacity':max, 'address':address, 'destination':destination, 'resource_id':resource_id}

def random_address():
  addresses = ["Address A", "Address B", "Address C", "Address D"]
  return random.choice(addresses)

def location(resource_id):
  NUM_QUEUES = 3
  address = random_address()
  destination = 'destination1'
  
  queues = []
  for i in range(0,NUM_QUEUES):
    queues.append(queue(address, destination, resource_id))
  
  return {'address':address, 'max_capacity':10, 'queues':queues}

def resource():
  NUM_LOCATIONS = 3
  resource_id = uuid.uuid1().hex
  max = 50
  sensor = sim_occupancy_sensor

  locations = []
  for i in range(0, NUM_LOCATIONS):
    locations.append(location(resource_id))
  
  return {'resource_id':resource_id, 'max_occupancy':max, 'occupancy_sensor':sensor, 'locations':locations}

def queue_schedule():
  NUM_RESOURCES = 3
  resources = []
  for i in range(0, NUM_RESOURCES):
    resources.append(resource())

  return resources

queue_schedule = queue_schedule()

class TestThatQueueScheduleHasStructureAndContent(unittest.TestCase):
  def test_for_resource_structure_and_content(self):
    self.assertTrue(len(queue_schedule) > 2)
  
  def test_for_resource_location_structure_and_content(self):
    self.assertTrue(len(queue_schedule[1]['locations']) > 2)

  def test_for_resource_location_queue_structure_and_content(self):
    self.assertTrue(len(queue_schedule[2]['locations'][1]['queues']) > 2)

  def test_relationships_between_queue_location_and_resource(self):
    self.assertEqual(queue_schedule[0]['locations'][0]['queues'][0]['address'], queue_schedule[0]['locations'][0]['address'])
    self.assertEqual(queue_schedule[0]['locations'][0]['queues'][0]['resource_id'], queue_schedule[0]['resource_id'])

class TestDataTypesOfQueueSchedule(unittest.TestCase):
  def test_data_types_of_resource_attributes(self):
    self.assertTrue(isinstance(queue_schedule[0]['resource_id'], str))
    self.assertTrue(isinstance(queue_schedule[0]['max_occupancy'], int))
    self.assertTrue(isinstance(queue_schedule[0]['occupancy_sensor'](), int))
  
  def test_data_types_of_location_attributes(self):
    self.assertTrue(isinstance(queue_schedule[0]['locations'], list))
    self.assertTrue(isinstance(queue_schedule[0]['locations'][0], dict))
    self.assertTrue(isinstance(queue_schedule[0]['locations'][0]['address'], str))
    self.assertTrue(isinstance(queue_schedule[0]['locations'][0]['max_capacity'], int))
    self.assertTrue(isinstance(queue_schedule[0]['locations'][0]['queues'], list))
  
  def test_data_types_of_queue_attributes(self):
    self.assertTrue(isinstance(queue_schedule[0]['locations'][0]['queues'][0]['queue_id'], str))
    self.assertTrue(isinstance(queue_schedule[0]['locations'][0]['queues'][0]['start_datetime'], arrow.arrow.Arrow))
    self.assertTrue(isinstance(queue_schedule[0]['locations'][0]['queues'][0]['end_datetime'], arrow.arrow.Arrow))
    self.assertNotEqual(queue_schedule[0]['locations'][0]['queues'][0]['start_datetime'].format('YYYY'),'0001')
    self.assertNotEqual(queue_schedule[0]['locations'][0]['queues'][0]['end_datetime'].format('YYYY'),'0001')
    self.assertTrue(isinstance(queue_schedule[0]['locations'][0]['queues'][0]['address'], str))
    self.assertTrue(isinstance(queue_schedule[0]['locations'][0]['queues'][0]['resource_id'], str))

unittest.main(argv=[''], verbosity=2, exit=False)

class TestReservation(unittest.TestCase):
  def setUp(self):
    person_id = "abc123"
    occupants = 3
    reward_points = 3
    self.reservation = Reservation(person_id, occupants, reward_points)

  def test_reservation_creation(self):
    self.assertEqual(self.reservation.person_id, "abc123")
    self.assertEqual(self.reservation.state, ReservationState.RESERVED)
    self.assertEqual(self.reservation.reward_points, 3)
    self.assertEqual(self.reservation.occupants, 3)
  
  def test_reservation_update(self):
    self.reservation.update(ReservationState.COMPLETED)
    self.assertEqual(self.reservation.state, ReservationState.COMPLETED)

unittest.main(argv=[''], verbosity=2, exit=False)

class TestQueue(unittest.TestCase):
  def setUp(self):
    open = arrow.get('2020-07-04 13:00', 'YYYY-MM-DD HH:mm')
    close = open.shift(minutes=+10)
    address = "123main"
    destination = 'destination1'
    resource_id = "resource1"
    self.queue = Queue("queue", 10, open, close, address, destination, resource_id)

  def test_queue_creation(self):
    self.assertTrue(isinstance(self.queue.id, str))
    self.assertTrue(isinstance(self.queue.open_datetime, arrow.arrow.Arrow))
    self.assertNotEqual(self.queue.open_datetime.format('YYYY'),'0001')
    self.assertTrue(isinstance(self.queue.close_datetime, arrow.arrow.Arrow))
    self.assertNotEqual(self.queue.close_datetime.format('YYYY'),'0001')
    self.assertEqual(self.queue.max_capacity, 10)
    self.assertEqual(self.queue.active_occupants(), 0)
    self.assertEqual(self.queue.address, '123main')
    self.assertEqual(self.queue.resource_id, 'resource1')

  def test_making_reservations(self):
    proof_of_purchase = 'purchase'
    occupants = 2
    reward_points = 0
    remaining_resource_capacity = 10
    remaining_location_capacity = 10

    result = self.queue.reserve("abc123", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.assertEqual(result['code'], ReserveActionResult.SUCCESS)
    self.assertEqual(self.queue.active_occupants(), 2)

    #the queue should ignore duplicate reservation requests
    result = self.queue.reserve("abc123", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.assertEqual(result['code'], ReserveActionResult.OTHER_FAILURE)
    self.assertEqual(self.queue.active_occupants(), 2)

    #active queues should honor new reservation requests
    occupants = 3
    self.queue.reserve("xyz456", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.queue.reserve("ijk789", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.assertEqual(self.queue.active_occupants(), 8)

    #terminated queues should not honor new reservation requests
    self.queue.terminate()
    self.queue.reserve("def789", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.assertEqual(result['code'], ReserveActionResult.OTHER_FAILURE)

    #there should be no active occupants in a terminated queue
    #you cannot make new reservations in a terminated queue
    self.assertEqual(self.queue.active_occupants(), 0)

  def test_canceling_reservations(self):
    proof_of_purchase = 'purchase'
    occupants = 3
    reward_points = 0
    remaining_resource_capacity = 10
    remaining_location_capacity = 10

    self.queue.reserve("abc123", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.queue.reserve("xyz456", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.queue.reserve("ijk789", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.assertEqual(self.queue.active_occupants(), 9)
    
    #canceling a reservation decreases active occupants
    self.queue.cancel_reservation("abc123")
    self.assertEqual(self.queue.active_occupants(), 6)

    #it is meaningless to cancel a non-existent reservation
    self.queue.cancel_reservation("nonexistent")
    self.assertEqual(self.queue.active_occupants(), 6)

    #it is meaningless to cancel rervations for a terminated queue
    self.queue.terminate()
    self.assertEqual(self.queue.active_occupants(), 0)
    self.queue.cancel_reservation("xyz456")
    self.assertEqual(self.queue.active_occupants(), 0)


  def test_completing_reservations(self):
    proof_of_purchase = 'purchase'
    occupants = 2
    reward_points = 0
    remaining_resource_capacity = 10
    remaining_location_capacity = 10

    self.queue.reserve("abc123", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.queue.reserve("xyz456", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.queue.reserve("ijk789", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.assertEqual(self.queue.active_occupants(), 6)

    #complete reservations remain active
    self.queue.complete_reservation("xyz456")
    self.assertEqual(self.queue.active_occupants(), 6)

    #you cannot complete a canceled reservation
    self.queue.cancel_reservation("abc123")
    self.queue.complete_reservation("abc123")
    self.assertEqual(self.queue.active_occupants(), 4)

    #you cannot complete a missed reservation
    self.queue.miss_reservation("ijk789")
    self.queue.complete_reservation("ijk789")
    self.assertEqual(self.queue.active_occupants(), 2)
    
    #you cannot complete a terminated reservation
    self.queue.reserve("aaa111", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.assertEqual(self.queue.reservation("aaa111").state, ReservationState.RESERVED)
    self.queue.terminate()
    self.assertEqual(self.queue.reservation("aaa111").state, ReservationState.TERMINATED)
    self.queue.complete_reservation("aaa111")
    self.assertEqual(self.queue.reservation("aaa111").state, ReservationState.TERMINATED)

  def test_missing_reservations(self):
    proof_of_purchase = 'purchase'
    occupants = 1
    reward_points = 0
    remaining_resource_capacity = 10
    remaining_location_capacity = 10

    self.queue.reserve("abc123", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.queue.reserve("xyz456", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.queue.reserve("ijk789", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.queue.reserve("def321", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.assertEqual(self.queue.active_occupants(), 4)

    #you cannot miss a canceled reservation
    self.queue.cancel_reservation("abc123")
    self.queue.miss_reservation("abc123")
    res = self.queue.reservation("abc123")
    self.assertEqual(res.state, ReservationState.CANCELED)

    #you cannot miss a completed reservation
    self.queue.complete_reservation("xyz456")
    self.queue.miss_reservation("xyz456")
    res = self.queue.reservation("xyz456")
    self.assertEqual(res.state, ReservationState.COMPLETED)

    #you can miss a rerserved reservation
    self.queue.miss_reservation("ijk789")
    res = self.queue.reservation("ijk789")
    self.assertEqual(res.state, ReservationState.MISSED)

    #you can miss a missed reservation
    self.queue.miss_reservation("def321")
    self.queue.miss_reservation("def321")
    res = self.queue.reservation("def321")
    self.assertEqual(res.state, ReservationState.MISSED)

    #you cannot miss a terminated reservation
    self.queue.reserve("aaa111", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.queue.terminate()
    self.assertEqual(self.queue.reservation("aaa111").state, ReservationState.TERMINATED)
    self.queue.miss_reservation("aaa111")
    self.assertEqual(self.queue.reservation("aaa111").state, ReservationState.TERMINATED)


  def test_terminating_queues(self):
    proof_of_purchase = 'purchase'
    occupants = 1
    reward_points = 0
    remaining_resource_capacity = 10
    remaining_location_capacity = 10

    self.queue.reserve("abc123", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.queue.reserve("xyz456", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.queue.reserve("ijk789", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.queue.reserve("def321", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)

    #all active reservations on a terminated queue must be terminated
    self.assertEqual(self.queue.reservation("abc123").state, ReservationState.RESERVED)
    self.assertEqual(self.queue.reservation("xyz456").state, ReservationState.RESERVED)
    self.assertEqual(self.queue.reservation("ijk789").state, ReservationState.RESERVED)
    self.assertEqual(self.queue.reservation("def321").state, ReservationState.RESERVED)
    self.queue.terminate()
    self.assertEqual(self.queue.reservation("abc123").state, ReservationState.TERMINATED)
    self.assertEqual(self.queue.reservation("xyz456").state, ReservationState.TERMINATED)
    self.assertEqual(self.queue.reservation("ijk789").state, ReservationState.TERMINATED)
    self.assertEqual(self.queue.reservation("def321").state, ReservationState.TERMINATED)

    #you cannot make a new reservation on a terminated queue
    result = self.queue.reserve("aaa111", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.assertEqual(result['code'], ReserveActionResult.OTHER_FAILURE)

  def test_terminating_reservations(self):
    proof_of_purchase = 'purchase'
    occupants = 1
    reward_points = 0
    remaining_resource_capacity = 10
    remaining_location_capacity = 10

    self.queue.reserve("abc123", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.queue.miss_reservation("abc123")

    self.queue.reserve("xyz456", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.queue.cancel_reservation("xyz456")

    self.queue.reserve("ijk789", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.queue.complete_reservation("ijk789")

    self.queue.terminate()

    #you cannot terminate a missed reservation
    self.assertEqual(self.queue.reservation("abc123").state, ReservationState.MISSED)

    #you cannot terminate a canceled reservation
    self.assertEqual(self.queue.reservation("xyz456").state, ReservationState.CANCELED)

    #you can terminate a completed reservation
    self.assertEqual(self.queue.reservation("ijk789").state, ReservationState.TERMINATED)

  def test_queue_capacity(self):
    proof_of_purchase = 'purchase'
    occupants = 1
    reward_points = 0

    #you cannot reserve past the resource capacity
    remaining_resource_capacity = 2
    remaining_location_capacity = 5
    self.queue.reserve("person1", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.queue.reserve("person2", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)

    remaining_resource_capacity = 0
    remaining_location_capacity = 3
    self.queue.reserve("person3", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.assertEqual(self.queue.active_occupants(), 2)

    #you cannot reserve past the location capacity
    remaining_resource_capacity = 2
    remaining_location_capacity = 5
    self.queue.reserve("person3", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)

    remaining_resource_capacity = 1
    remaining_location_capacity = 0
    self.queue.reserve("person4", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.assertEqual(self.queue.active_occupants(), 3)

    #you cannot reserve past the queue capacity
    occupants = 3
    remaining_resource_capacity = 10
    remaining_location_capacity = 10
    self.queue.reserve("person4", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.queue.reserve("person5", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.queue.reserve("person6", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.assertEqual(self.queue.active_occupants(), 9)
  
  def test_reward_points_calculation_of_a_queue(self):
    proof_of_purchase = 'purchase'
    occupants = 1
    remaining_resource_capacity = 10
    remaining_location_capacity = 10

    #a high-capacity queue is worth a lot
    high_reward = self.queue.reward(remaining_resource_capacity, remaining_location_capacity)
    self.assertEqual(high_reward, 1.0)

    #a lower-capacity queue is worth less
    stubbed_reward_points  = 1
    self.queue.reserve("person1", proof_of_purchase, occupants, stubbed_reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.queue.reserve("person2", proof_of_purchase, occupants, stubbed_reward_points, remaining_resource_capacity, remaining_location_capacity)
    middle_reward = self.queue.reward(remaining_resource_capacity, remaining_location_capacity)
    self.assertEqual(middle_reward, 0.8)

    #the resource capacity affects the queue reward
    remaining_resource_capacity = 2
    little_reward = self.queue.reward(remaining_resource_capacity, remaining_location_capacity)
    self.assertEqual(little_reward, 0.2)

    #the location capacity affects the queue reward
    remaining_location_capacity = 0
    no_reward = self.queue.reward(remaining_resource_capacity, remaining_location_capacity)
    self.assertEqual(no_reward, 0.0)

unittest.main(argv=[''], verbosity=2, exit=False)

class TestLocation(unittest.TestCase):
  def setUp(self):
    address = "123 Main St"
    max_capacity = 50
    self.location = Location(address, max_capacity)

  def test_location_creation(self):
    self.assertEqual(self.location.address,'123 Main St')
    self.assertEqual(self.location.max_capacity,50)

  def test_adding_queues(self):
    self.assertEqual(len(self.location.queues),0)

    open = arrow.get('2020-07-04 13:00', 'YYYY-MM-DD HH:mm')
    close = open.shift(minutes=+10)
    address = '123main'
    destination = 'dest'
    resource_id = 'resource1'
    queue = Queue("queue", 5, open, close, address, destination, resource_id)
    self.location.add_queue(queue)

    self.assertEqual(len(self.location.queues),1)
  
  def test_location_capacity(self):
    #set up 3 overlapping queues and make reservations
    
    default_queue_max_capacity = 5
    remaining_resource_capacity = 10
    address = '123main'
    destination = 'destination1'
    resource_id = 'resource1'
    proof_of_purchase = 'purchase'
    occupants = 1
    reward_points = 10
    
    #queue 1
    queue1_open = arrow.get('2020-07-04 13:00', 'YYYY-MM-DD HH:mm')
    queue1_close = arrow.get('2020-07-04 13:16', 'YYYY-MM-DD HH:mm')
    queue1 = Queue("queue1", default_queue_max_capacity, queue1_open, queue1_close, address, destination, resource_id)
    self.location.add_queue(queue1)
    remaining_location_capacity = self.location.remaining_capacity(queue1_open, queue1_close)
    self.location.queues[0].reserve("person1", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    
    #queue 2
    queue2_open = arrow.get('2020-07-04 13:05', 'YYYY-MM-DD HH:mm')
    queue2_close = arrow.get('2020-07-04 13:14', 'YYYY-MM-DD HH:mm')
    queue2 = Queue("queue2", default_queue_max_capacity, queue2_open, queue2_close, address, destination, resource_id)
    self.location.add_queue(queue2)
    remaining_location_capacity = self.location.remaining_capacity(queue2_open, queue2_close)
    self.location.queues[1].reserve("person2", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.location.queues[1].reserve("person3", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.location.queues[1].reserve("person4", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)

    #queue 3
    queue3_open = arrow.get('2020-07-04 13:13', 'YYYY-MM-DD HH:mm')
    queue3_close = arrow.get('2020-07-04 13:20', 'YYYY-MM-DD HH:mm')
    queue3 = Queue("queue3", default_queue_max_capacity, queue3_open, queue1_close, address, destination, resource_id)
    self.location.add_queue(queue3)
    remaining_location_capacity = self.location.remaining_capacity(queue3_open, queue3_close)
    self.location.queues[2].reserve("person5", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.location.queues[2].reserve("person6", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)

    #set up a time range that falls within 2 of the queues
    query_start = arrow.get('2020-07-04 13:00', 'YYYY-MM-DD HH:mm')
    query_end = arrow.get('2020-07-04 13:12', 'YYYY-MM-DD HH:mm')

    #test for remaining location capacity given the time range
    self.assertEqual(self.location.remaining_capacity(query_start, query_end), 46)

  def test_location_capacitys_effect_on_queue_capacity(self):
    #create a location with two queues
    self.location.max_capacity = 2
    default_queue_max_capacity = 5
    address ='123main'
    destination = 'destination1'
    resource_id = 'resource1'
    proof_of_purchase = 'purchase'
    occupants = 1
    reward_points = 10
    
    #queue 1
    queue1_open = arrow.get('2020-07-04 13:00', 'YYYY-MM-DD HH:mm')
    queue1_close = arrow.get('2020-07-04 13:16', 'YYYY-MM-DD HH:mm')
    queue1 = Queue("queue1", default_queue_max_capacity, queue1_open, queue1_close, address, destination, resource_id)
    self.location.add_queue(queue1)

    #queue 2
    queue2_open = arrow.get('2020-07-04 13:05', 'YYYY-MM-DD HH:mm')
    queue2_close = arrow.get('2020-07-04 13:14', 'YYYY-MM-DD HH:mm')
    queue2 = Queue("queue2", default_queue_max_capacity, queue2_open, queue2_close, address, destination, resource_id)
    self.location.add_queue(queue2)

    remaining_resource_capacity = 10

    #add to the first queue and check the location's capacity
    remaining_location_capacity = self.location.remaining_capacity(queue1_open, queue1_close)
    self.location.queues[0].reserve("person1", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.assertEqual(self.location.remaining_capacity(queue1_open, queue1_close),1)

    #add to the second queue and check the locations's capacity
    remaining_location_capacity = self.location.remaining_capacity(queue2_open, queue2_close)
    self.location.queues[1].reserve("person2", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.assertEqual(self.location.remaining_capacity(queue2_open, queue2_close),0)

    #attempt to overload the location
    remaining_location_capacity = self.location.remaining_capacity(queue2_open, queue2_close)
    result = self.location.queues[0].reserve("person3", proof_of_purchase, occupants, reward_points, remaining_resource_capacity, remaining_location_capacity)
    self.assertEqual(result['code'], ReserveActionResult.OTHER_FAILURE)
    self.assertEqual(self.location.remaining_capacity(queue2_open, queue2_close),0)

unittest.main(argv=[''], verbosity=2, exit=False)

class TestResource(unittest.TestCase):
  def setUp(self):
    id = "resource1"
    max_occupancy = 10
    occupant_sensor = sim_occupancy_sensor
    self.resource = Resource(id, max_occupancy, occupant_sensor)
  
  def test_resource_creation(self):
    self.assertEqual(self.resource.id, "resource1")
    self.assertEqual(self.resource.capacity, 10)

  def test_occupant_sensor(self):
    self.assertTrue(0 <= self.resource.occupants() <= 50)

  def test_remaining_capacity(self):
    self.assertTrue(self.resource.remaining_capacity() <= 10)

unittest.main(argv=[''], verbosity=2, exit=False)

class TestSmartQueue(unittest.TestCase):

  def setUp(self):
    queue_schedule = [
                      {'resource_id':'resource1', 
                      'max_occupancy':5, 
                      'occupancy_sensor':dummy_sensor, 
                      'locations':[{'address':'address1', 
                                    'max_capacity':3, 
                                    'queues':[{'queue_id':'queue1', 
                                                'start_datetime':arrow.get('2020-07-06 13:00', 'YYYY-MM-DD HH:mm'), 
                                                'end_datetime':arrow.get('2020-07-06 13:10', 'YYYY-MM-DD HH:mm'), 
                                                'max_capacity':6, 
                                                'address':'address1',
                                                "destination": "destination1",
                                                'resource_id':'resource1'}
                                              ]
                                    }
                                    ]
                      },
                      {'resource_id':'resource2', 
                      'max_occupancy':4, 
                      'occupancy_sensor':dummy_sensor, 
                      'locations':[{'address':'address2', 
                                    'max_capacity':5,   
                                    'queues':[{'queue_id':'queue2', 
                                                'start_datetime':arrow.get('2020-07-06 13:00', 'YYYY-MM-DD HH:mm'), 
                                                'end_datetime':arrow.get('2020-07-06 13:10', 'YYYY-MM-DD HH:mm'), 
                                                'max_capacity':2, 
                                                'address':'address2',
                                                "destination": "destination1",
                                                'resource_id':'resource2'},
                                              {'queue_id':'queue3', 
                                                'start_datetime':arrow.get('2020-07-06 13:10', 'YYYY-MM-DD HH:mm'), 
                                                'end_datetime':arrow.get('2020-07-06 13:20', 'YYYY-MM-DD HH:mm'), 
                                                'max_capacity':3, 
                                                'address':'address2',
                                                "destination": "destination1", 
                                                'resource_id':'resource2'}
                                              ]
                                    }
                                    ]
                      }    
    ]
    
    self.smartqueue = SmartQueue(queue_schedule)
  
  def test_queue_update(self):
    #test adding a new resource
    queue_schedule = [
                      {'resource_id':'resource3', 
                      'max_occupancy':5, 
                      'occupancy_sensor':dummy_sensor, 
                      'locations':[{'address':'address1', 
                                    'max_capacity':3, 
                                    'queues':[{'queue_id':'queue4', 
                                                'start_datetime':arrow.get('2020-07-06 13:00', 'YYYY-MM-DD HH:mm'), 
                                                'end_datetime':arrow.get('2020-07-06 13:10', 'YYYY-MM-DD HH:mm'), 
                                                'max_capacity':6, 
                                                'address':'address1',
                                                "destination": "destination1", 
                                                'resource_id':'resource3'}
                                              ]
                                    }
                                    ]
                      }
    ]
    self.smartqueue.update(queue_schedule)

    start_datetime = arrow.get('2020-07-06 13:00', 'YYYY-MM-DD HH:mm')
    end_datetime = arrow.get('2020-07-06 13:20', 'YYYY-MM-DD HH:mm')
    queue_options = self.smartqueue.list_queue_options('resource3', 'address1', 'destination1', start_datetime, end_datetime)
    self.assertEqual(len(queue_options), 2)

    #test addding a new location
    queue_schedule = [
                      {'resource_id':'resource3', 
                      'max_occupancy':5, 
                      'occupancy_sensor':dummy_sensor, 
                      'locations':[{'address':'address3', 
                                    'max_capacity':3, 
                                    'queues':[{'queue_id':'queue5', 
                                                'start_datetime':arrow.get('2020-07-06 13:00', 'YYYY-MM-DD HH:mm'), 
                                                'end_datetime':arrow.get('2020-07-06 13:10', 'YYYY-MM-DD HH:mm'), 
                                                'max_capacity':6, 
                                                'address':'address3',
                                                'destination': 'destination1',
                                                'resource_id':'resource3'}
                                              ]
                                    }
                                    ]
                      }
    ]
    self.smartqueue.update(queue_schedule)

    start_datetime = arrow.get('2020-07-06 13:00', 'YYYY-MM-DD HH:mm')
    end_datetime = arrow.get('2020-07-06 13:20', 'YYYY-MM-DD HH:mm')
    queue_options = self.smartqueue.list_queue_options('resource3', 'address3', 'destination1', start_datetime, end_datetime)
    self.assertEqual(len(queue_options), 1)

    #ignore duplicate resources and locations
    queue_schedule = [
                      {'resource_id':'resource3', 
                      'max_occupancy':5, 
                      'occupancy_sensor':dummy_sensor, 
                      'locations':[{'address':'address3', 
                                    'max_capacity':3, 
                                    'queues':[{'queue_id':'queue6', 
                                                'start_datetime':arrow.get('2020-07-06 13:00', 'YYYY-MM-DD HH:mm'), 
                                                'end_datetime':arrow.get('2020-07-06 13:10', 'YYYY-MM-DD HH:mm'), 
                                                'max_capacity':6, 
                                                'address':'address1',
                                                'destination': 'destination1',
                                                'resource_id':'resource1'}
                                              ]
                                    }
                                    ]
                      }
    ]

    self.assertEqual(len(self.smartqueue.debug_resources()),3)
    self.assertEqual(len(self.smartqueue.debug_locations()),3)
    self.assertEqual(len(self.smartqueue.debug_queues()),5)

    self.smartqueue.update(queue_schedule)

    self.assertEqual(len(self.smartqueue.debug_resources()),3)
    self.assertEqual(len(self.smartqueue.debug_locations()),3)
    self.assertEqual(len(self.smartqueue.debug_queues()),6)


  def test_queue_options(self):
    #find available queues for resource 1
    start_datetime = arrow.get('2020-07-06 13:00', 'YYYY-MM-DD HH:mm')
    end_datetime = arrow.get('2020-07-06 13:20', 'YYYY-MM-DD HH:mm')
    queue_options = self.smartqueue.list_queue_options('resource1', 'address1', 'destination1', start_datetime, end_datetime)
    self.assertEqual(len(queue_options), 1)

    #make a reservation
    proof_of_purchase = 'proof'
    occupants = 3
    queue_id = queue_options[0]['queue_id']
    result = self.smartqueue.reserve('person1', proof_of_purchase, occupants, queue_id)
    self.assertEqual(result['code'], ReserveActionResult.SUCCESS)

    #find available queues for resource 1
    queue_options = self.smartqueue.list_queue_options('resource1', 'address1', 'destination1', start_datetime, end_datetime)

    #queues with no capacity should not be listed as an option
    self.assertEqual(len(queue_options), 0)


  def test_reservation_creation(self):
    #check that there are no reservations
    reservation_list = self.smartqueue.list_reservations("person1")
    self.assertTrue(isinstance(reservation_list, list))
    self.assertEqual(len(reservation_list), 0)

    #find available queues for resource 1
    start_datetime = arrow.get('2020-07-06 13:00', 'YYYY-MM-DD HH:mm')
    end_datetime = arrow.get('2020-07-06 13:10', 'YYYY-MM-DD HH:mm')
    queue_options = self.smartqueue.list_queue_options('resource1', 'address1', 'destination1', start_datetime, end_datetime)
    self.assertEqual(len(queue_options), 1)

    #make a reservation for resource 1
    proof_of_purchase = 'proof'
    occupants = 1
    queue_id = queue_options[0]['queue_id']
    result = self.smartqueue.reserve('person1', proof_of_purchase, occupants, queue_id)
    self.assertEqual(result['code'], ReserveActionResult.SUCCESS)

    #check that the new reservation exists
    reservation_list = self.smartqueue.list_reservations('person1')
    self.assertEqual(len(reservation_list),1)
    self.assertEqual(reservation_list[0]['resource'],'resource1')

    #find available queues for resource 2
    start_datetime = arrow.get('2020-07-06 13:00', 'YYYY-MM-DD HH:mm')
    end_datetime = arrow.get('2020-07-06 13:20', 'YYYY-MM-DD HH:mm')
    queue_options = self.smartqueue.list_queue_options('resource2', 'address2', 'destination1', start_datetime, end_datetime)
    self.assertEqual(len(queue_options), 2)

    #make a reservation for the first queue option for resource 2
    queue_id = queue_options[0]['queue_id']
    result = self.smartqueue.reserve('person1', proof_of_purchase, occupants, queue_id)
    self.assertEqual(result['code'], ReserveActionResult.SUCCESS)

    #check the remaining reward points of queues for resource 1
    start_datetime = arrow.get('2020-07-06 13:05', 'YYYY-MM-DD HH:mm')
    end_datetime = arrow.get('2020-07-06 13:15', 'YYYY-MM-DD HH:mm')
    queue_options = self.smartqueue.list_queue_options('resource1', 'address1', 'destination1', start_datetime, end_datetime)
    one_third = 1/3
    self.assertEqual(queue_options[0]['reward'],one_third)

    #check the remaining reward points of queues for resource 2
    start_datetime = arrow.get('2020-07-06 12:50', 'YYYY-MM-DD HH:mm')
    end_datetime = arrow.get('2020-07-06 13:11', 'YYYY-MM-DD HH:mm')
    queue_options = self.smartqueue.list_queue_options('resource2', 'address2', 'destination1', start_datetime, end_datetime)
    self.assertEqual(queue_options[0]['reward'],0.5)
    self.assertEqual(queue_options[1]['reward'],1)
  
  def test_double_booking_reservations(self):
    #TODO:
    pass

  def test_queue_termination(self):
    #TODO:
    #make reservations
    #check for the reservations
    #terminate a queue at a location and outside our timeframe
    #the reservation should still exist
    #terminate a queue at a location and inside our timeframe
    #the reservation should be impacted
    #terminate a queue for a resource and outside our timeframe
    #the reservation should still exist
    #terminate a queue for a resource and inside our timeframe
    #the reservation should be impacted
    pass


unittest.main(argv=[''], verbosity=2, exit=False)

