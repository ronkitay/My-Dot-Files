#!/bin/bash

for arg in "$@"; do
  task $arg modify wait:friday+8h
done

