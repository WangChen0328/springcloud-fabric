rm -rf ./channel-artifacts
rm -rf ./crypto-config
docker rm -f $(docker ps -a -q)
