#!/bin/bash
docker run -d -ti -p 8003:8000 -v `pwd`/images:/opt/presentation/images -v `pwd`/build:/build -v `pwd`:/opt/presentation/lib/md rossbachp/presentation
