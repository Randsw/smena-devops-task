FROM python:3.9-slim

# create the app user
ENV HOME /home/user
RUN useradd --create-home --home-dir $HOME user \
    && mkdir -p $HOME \
    && chown -R user:user $HOME

ENV APP_HOME=/home/user/web
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN pip install poetry  

COPY poetry.lock poetry.toml pyproject.toml ./

RUN poetry install --no-dev

ENV PATH="$APP_HOME/.venv/bin:$PATH"

COPY . .

RUN chown -R user:user $APP_HOME && chmod +x gunicorn.sh

# change to the app user
USER user

EXPOSE 8000

CMD ["/home/user/web/gunicorn.sh"]