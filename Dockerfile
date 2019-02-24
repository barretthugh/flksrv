FROM node:lts-alpine

ENV TZ=Asia/Shanghai

COPY requirement.txt /requirement.txt
COPY jupyter_notebook_config.py /root/.jupyter/
# for mirrors in China
# COPY source.list /etc/apt/sources.list
# COPY pip.conf /root/.pip/pip.conf

USER root

RUN echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories \
  && echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories \
  && apk add --update-cache alpine-sdk python3-dev py3-zmq python-dev py-pip chromium@edge harfbuzz@edge nss@edge \
	&& pip3 install -r /requirement.txt \
  && curl https://chromedriver.storage.googleapis.com/73.0.3683.20/chromedriver_linux64.zip -o /usr/local/bin/chromedriver.zip \
  && unzip /usr/local/bin/chromedriver.zip \
  && mv /chromedriver /usr/local/bin/ \
  && chmod +x /usr/local/bin/chromedriver \
  && rm /usr/local/bin/chromedriver.zip \
  && rm /chrome.deb \
	&& pip3 install Tushare \
  && pip3 install prompt_toolkit \
  && jupyter nbextension enable --py widgetsnbextension \
  && jupyter serverextension enable --py jupyterlab \
  && npm --unsafe-perm i -g ijavascript \
  && ijsinstall --install=global \
  && npm i d3 crossfilter2 dc jquery melt \
  && rm -rf /var/cache/*

WORKDIR "/"

EXPOSE 666 9000 8888
CMD ["jupyter", "lab", "--allow-root"]
