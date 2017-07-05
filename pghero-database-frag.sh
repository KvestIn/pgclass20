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

DATABASE=frag

docker stop pghero-$USERNAME-$PROJECT-frag
docker rm -f pghero-$USERNAME-$PROJECT-frag

echo "PGHero will monitor ${DATABASE}"
echo "PGHero try to link container with postgres-$USERNAME-$PROJECT-frag"

docker run -d $DNSOPTIONS --restart="on-failure:1" --name=pghero-$USERNAME-$PROJECT-frag \
        --link postgres-$USERNAME-$PROJECT:db \
        -e DATABASE_URL=postgres://postgres@db:5432/$DATABASE -p 9997:8080 bmorton/pghero
