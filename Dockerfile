FROM python:3.9-alpine3.13
LABEL maintainer="mpho"

ENV PYTHONUNBUFFERED 1

#this copy the requirements from local machine to docker container used to install the requirements
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

#Copy the app directory that contains our app to the container
COPY ./app /app

#This is a default working directory will be used to run our commands on a docker container
# Set it to the location of your django project
WORKDIR /app

#Allows us to access the port on the container
EXPOSE 8000

ARG DEV=false

# 1. Create a virtual environment
# 2. Upgrade the pip
# 3. Install the depedencies on the copied requirements.txt file
# Added: Check if the dev variable is set to true to only install flake on development
# 4. delete the tmp directory to keep the container light because we don`t need it
# 5. Add a user, it is a best practice no to use a root account
# 6. The created user will not use a password
# 7. A user will be called django-user
# 8. Create a Path so that we don`t use /py/bin every time
# 9. Log in as django-user, this won`t have root permissions

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [$DEV = 'true']; \
        then /py/bin/pip insta ll -r /tmp/requirements.dev.txt ; \
    fi && \   
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user

 