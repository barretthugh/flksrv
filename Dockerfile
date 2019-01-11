FROM python:3.6.6-jessie

ENV TZ=Asia/Shanghai

COPY requirement.txt /requirement.txt
COPY jupyter_notebook_config.py /root/.jupyter/
# for mirrors in China
# COPY source.list /etc/apt/sources.list
# COPY pip.conf /root/.pip/pip.conf

USER root

RUN apt-get update \
  && apt-get install -y unzip \
	&& pip install -r /requirement.txt \
  && curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /chrome.deb \
	&& dpkg -i /chrome.deb || apt-get install -yf \
  && curl https://chromedriver.storage.googleapis.com/2.45/chromedriver_linux64.zip -o /usr/local/bin/chromedriver.zip \
  && unzip /usr/local/bin/chromedriver.zip \
  && mv /chromedriver /usr/local/bin/ \
  && chmod +x /usr/local/bin/chromedriver \
  && rm /usr/local/bin/chromedriver.zip \
  && rm /chrome.deb \
	&& pip install Tushare \
  && pip install prompt_toolkit \
  && jupyter nbextension enable --py widgetsnbextension \
  && jupyter serverextension enable --py jupyterlab

WORKDIR "/"

EXPOSE 666 9000 8888
CMD ["jupyter", "lab", "--allow-root"]
