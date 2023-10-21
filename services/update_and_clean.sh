#!/bin/bash

dnf update -y
dnf autoremove -y
dnf clean all
