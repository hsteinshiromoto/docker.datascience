# ---
# Build arguments
# ---
ARG DOCKER_PARENT_IMAGE
FROM $DOCKER_PARENT_IMAGE

# NB: Arguments should come after FROM otherwise they're deleted
ARG BUILD_DATE

# Silence debconf
ARG DEBIAN_FRONTEND=noninteractive


# ---
# Enviroment variables
# ---
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8
ENV TZ Australia/Sydney
ENV JUPYTER_ENABLE_LAB=yes
ENV SHELL=/bin/bash
ENV HOME=/home/$USERNAME

# Set container time zone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

LABEL org.label-schema.build-date=$BUILD_DATE \
        maintainer="Humberto STEIN SHIROMOTO <h.stein.shiromoto@gmail.com>"

# ---
# Copy Container Setup Scripts
# ---
COPY poetry.lock /usr/local/poetry.lock
COPY pyproject.toml /usr/local/pyproject.toml

RUN chmod +x /usr/local/bin/entrypoint.sh

# Create the "home" folder
RUN mkdir -p /home/$USERNAME
WORKDIR /home/$USERNAME

# N.B.: Keep the order 1. entrypoint, 2. cmd
USER $USERNAME

# Get poetry
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
ENV PATH="${PATH}:$HOME/.poetry/bin"
ENV PATH="${PATH}:$HOME/.local/bin"

RUN poetry config virtualenvs.create false \
    && cd /usr/local \
    && poetry install --no-interaction --no-ansi

EXPOSE 8888
CMD ["jupyter", "lab", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]