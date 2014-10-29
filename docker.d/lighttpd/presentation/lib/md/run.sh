#!/bin/bash
docker run -d -ti -p 8000:8000 -v `pwd`/images:/opt/presentation/images -v `pwd`/build:/build -v `pwd`:/opt/presentation/lib/md rossbachp/presentation
