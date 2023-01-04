# Use the official lightweight Python image.
# https://hub.docker.com/_/python
# Specifying Version Number:
## Makes Build Immutablke (lytest may change)
## ensured dont download ALL versions
## 	 c1318d8f717b latest m101 SIZE: 7.2 GB		
FROM gcr.io/deeplearning-platform-release/pytorch-gpu.1-12:m101

# Copy local code to the container image.
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . ./

# Install production dependencies.
RUN pip install Flask gunicorn

# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 app:app
