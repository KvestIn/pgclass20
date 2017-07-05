#!/bin/bash
if [ -f .env ]; then
    source .env
fi

if [ -z $PROJECT ]; then
    PROJECT="pgsteroids"
fi
if [ -z $USERNAME ]; then
    USERNAME="vasya"
fi

DATABASE=bsp-btrfs

docker stop pghero-$USERNAME-$PROJECT-bsp-btrfs
docker rm -f pghero-$USERNAME-$PROJECT-bsp-btrfs

echo "PGHero will monitor ${DATABASE}"
echo "PGHero try to link container with postgres-$USERNAME-$PROJECT-bsp-btrfs"

docker run -d $DNSOPTIONS --restart="on-failure:1" --name=pghero-$USERNAME-$PROJECT-bsp-btrfs \
        --link postgres-$USERNAME-$PROJECT:db \
        -e DATABASE_URL=postgres://postgres@db:5432/$DATABASE -p 9998:8080 bmorton/pghero
