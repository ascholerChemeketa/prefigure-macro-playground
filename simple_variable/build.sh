#!/usr/bin/env bash
xsltproc variable-macro.xsl diagram-raw.xml > processed/diagram.xml
prefig build processed/diagram.xml