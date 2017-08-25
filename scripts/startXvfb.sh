export DISPLAY=:9
Xvfb :9 -shmem -screen 0 1366x768x16 &
# selenium must be started by a non-root user otherwise chrome can't start
su - seleuser -c "selenium-standalone start"

