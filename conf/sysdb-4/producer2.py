#!/usr/bin/env python3
# coding=utf-8
import pika

credentials = pika.PlainCredentials(username='yuliya', password='pass123')
connection = pika.BlockingConnection(pika.ConnectionParameters('10.0.3.7', credentials=credentials))
channel = connection.channel()
channel.queue_declare(queue='hello')
channel.basic_publish(exchange='', routing_key='hello', body='Hello Netology!')
print(" [x] Sent 'Hello Netology!'")
connection.close()
