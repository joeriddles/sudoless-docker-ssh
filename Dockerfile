FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends dialog \
    && apt-get install -y --no-install-recommends openssh-server

RUN apt-get install -y --no-install-recommends sudo

# SSH
RUN ssh-keygen -A
RUN echo "root:Docker!" | chpasswd
COPY /sshd_config /etc/ssh/
EXPOSE 8000 2222

RUN groupadd -r appuser && useradd --shell /bin/bash -g appuser appuser \
    && adduser appuser sudo \
    && echo 'appuser ALL=NOPASSWD: /usr/sbin/service ssh start' >> /etc/sudoers

RUN mkdir -p /var/run/sshd /home/appuser/.ssh && \
    chown -R appuser:appuser /var/run/sshd /home/appuser/.ssh && \
    chmod 700 /home/appuser/.ssh && \
    chmod -R u+r /etc/ssh/

USER appuser
CMD [ "sudo", "service", "ssh", "start" ]
