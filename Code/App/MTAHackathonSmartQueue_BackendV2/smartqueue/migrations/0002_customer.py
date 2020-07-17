# Generated by Django 3.0.8 on 2020-07-15 04:00

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('smartqueue', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Customer',
            fields=[
                ('queue_id', models.UUIDField(primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=30)),
                ('reward_points', models.IntegerField()),
            ],
            options={
                'db_table': 'customers',
            },
        ),
    ]
