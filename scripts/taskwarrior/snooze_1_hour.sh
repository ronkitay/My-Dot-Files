#!/bin/bash

for arg in "$@"; do
  task $arg modify wait:+1h
done

