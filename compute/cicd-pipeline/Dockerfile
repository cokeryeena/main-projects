FROM public.ecr.aws/docker/library/python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir flask
COPY . .
EXPOSE 8080
CMD ["python", "app/app.py"]

