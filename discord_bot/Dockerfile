FROM python:3.10-slim

WORKDIR /bot

RUN pip install discord

RUN pip install boto3

COPY . /bot

CMD [ "python3", "main.py" ]