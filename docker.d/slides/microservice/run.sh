#!/bin/bash
docker run -d -ti -p 8000:8000 -v `pwd`/images:/opt/presentation/images -v `pwd`:/opt/presentation/md rossbachp/presentation
