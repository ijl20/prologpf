#!/bin/bash

ps aux | grep "ppc $HOSTNAME" | grep -v grep
