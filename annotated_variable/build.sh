#!/usr/bin/env bash
xsltproc variable-annotation-macro.xsl diagram-raw.xml > processed/diagram.xml
prefig build processed/diagram.xml