FROM alpine-android

RUN apk --no-cache add \
      bash \
      fluxbox \
      git \
      supervisor \
      xvfb \
      x11vnc

RUN git clone --depth 1 https://github.com/novnc/noVNC.git /root/noVNC && \
      git clone --depth 1 https://github.com/novnc/websockify /root/noVNC/utils/websockify && \
      rm -rf /root/noVNC/.git && \
      rm -rf /root/noVNC/utils/websockify/.git && \
      apk del git && \
      sed -i -- "s/ps -p/ps -o pid | grep/g" /root/noVNC/utils/launch.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 8080

ENV DISPLAY=:0.0 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768

RUN sdkmanager "system-images;android-25;google_apis;x86_64"
# RUN echo "no" | avdmanager create avd -n Android_7.1_API_25 -k "system-images;android-25;google_apis;x86_64" -c 100M --abi google_apis/x86_64 --force
# RUN avdmanager create avd -n test -k "system-images;android-28;google_apis;x86"
# RUN avdmanager create avd -n emuTest -k "system-images;android-28;default;armeabi-v7a"

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

