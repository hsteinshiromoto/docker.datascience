# ---
# Build arguments
# ---
ARG DOCKER_PARENT_IMAGE
FROM $DOCKER_PARENT_IMAGE

# NB: Arguments should come after FROM otherwise they're deleted
ARG BUILD_DATE
ARG PYTHON_VERSION

# Silence debconf
ARG DEBIAN_FRONTEND=noninteractive

ARG PROJECT_NAME

# ---
# Enviroment variables
# ---
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8
ENV TZ Australia/Sydney
ENV JUPYTER_ENABLE_LAB=yes
ENV SHELL=/bin/bash
ENV PROJECT_NAME=$PROJECT_NAME
ENV HOME=/home/$PROJECT_NAME
ENV PYTHON_VERSION=$PYTHON_VERSION

# Set container time zone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

LABEL org.label-schema.build-date=$BUILD_DATE \
        maintainer="Humberto STEIN SHIROMOTO <h.stein.shiromoto@gmail.com>"

# Create the "home" folder
RUN mkdir -p $HOME
WORKDIR $HOME

COPY . $HOME/
RUN chmod +x $HOME/bin/start.sh

# Install pyenv dependencies
RUN apt-get update && \
    apt-get install -y build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev git git-flow &&\
    apt-get clean

RUN git clone --depth=1 https://github.com/pyenv/pyenv.git $HOME/.pyenv
ENV PYENV_ROOT="${HOME}/.pyenv"
ENV PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PATH}"

# ---
# Install Python and set the correct version
# ---
RUN pyenv install $PYTHON_VERSION && pyenv global $PYTHON_VERSION

RUN apt-get update && apt-get install vim gnupg2 make curl wget tree -y && apt-get clean

# Get poetry
RUN pip install poetry

RUN poetry config virtualenvs.create false \ 
    && poetry install --no-interaction --no-ansi

ENV PATH="${PATH}:$HOME/.local/bin"

# Add plugin to update the package versions [1]
RUN poetry self add poetry-plugin-up

# Need for Pytest
ENV PATH="${PATH}:${PYENV_ROOT}/versions/$PYTHON_VERSION/bin"

# Install VSCode server
RUN curl -fsSL https://code-server.dev/install.sh | sh

EXPOSE 8888 8080
CMD bash bin/start.sh

# References
# [1] https://github.com/python-poetry/poetry/issues/461#issuecomment-1348696119