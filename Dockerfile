FROM public.ecr.aws/lambda/python:3.10 as chronium

ARG branch_base_position="1121454"

RUN yum -y install unzip

# Download chromium and chromedriver
RUN curl -Lo "/tmp/chromium.zip" "https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F${branch_base_position}%2Fchrome-linux.zip?alt=media"

RUN unzip /tmp/chromium.zip -d /opt

RUN curl -Lo "/tmp/chromedriver.zip" "https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F${branch_base_position}%2Fchromedriver_linux64.zip?alt=media"
RUN unzip -j /tmp/chromedriver.zip -d /opt


FROM public.ecr.aws/lambda/python:3.10 as base

# Install chromium dependency modules
COPY chrome_deps.txt /tmp/
RUN yum install -y $(cat /tmp/chrome_deps.txt)

COPY requirements.txt /tmp/
RUN python3 -m pip install --upgrade pip -q
RUN python3 -m pip install -r /tmp/requirements.txt --no-cache-dir

COPY --from=chronium /opt/chrome-linux /opt/chrome-linux
COPY --from=chronium /opt/chromedriver /opt/chromedriver
COPY app.py .

CMD ["app.lambda_handler"]
