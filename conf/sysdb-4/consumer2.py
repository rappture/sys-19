#!/usr/bin/env python3
# coding=utf-8
import pika, sys, os

def main():
    credentials = pika.PlainCredentials(username='yuliya', password='pass123')
    connection = pika.BlockingConnection(pika.ConnectionParameters('10.0.3.7', credentials=credentials))
    channel = connection.channel()
    
    channel.queue_declare(queue='hello')

    def callback(ch, method, properties, body):
        print(" [x] Received %r" % body)

    channel.basic_consume(queue='hello', on_message_callback=callback, auto_ack=True)

    print(' [*] Waiting for messages. To exit press CTRL+C')
    channel.start_consuming()

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print('Interrupted')
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)
