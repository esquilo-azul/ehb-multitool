#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
from builtins import range
import cv2
import numpy
import os
import subprocess
import sys


class UniqueColors:
  def run(self):
    self.__listColors()
    if self.show:
      self.__showColors()

  def __listColors(self):
    for (bgr, hsv) in self.__sortedUniqueColors():
      print(self.__bgrToHexString(bgr))

  def __showColors(self):
    colors = self.__sortedUniqueColors()
    w = 256
    h = 32
    image = numpy.ndarray((h * len(colors), w * 2, 3), dtype=numpy.uint8)
    for i in range(len(colors)):
      pt1 = (0, i * h)
      pt2 = (w, pt1[1] + h)
      color = [int(c) for c in colors[i][0]]
      textColor = (255, 255, 255)
      cv2.rectangle(image, pt1, pt2, color, thickness=-1)
      text = "%s => %s" % (self.__bgrToHexString(
          colors[i][0]), str(colors[i][1]))
      textSize = cv2.getTextSize(text,
                                 fontFace=cv2.FONT_HERSHEY_PLAIN,
                                 fontScale=1,
                                 thickness=1)
      org = (int(pt2[0] + h / 2), int(pt2[1] - (h - textSize[0][1]) / 2))
      cv2.putText(image,
                  text,
                  org=org,
                  fontFace=cv2.FONT_HERSHEY_PLAIN,
                  fontScale=1,
                  color=textColor,
                  thickness=1)
    cv2.imshow("Main", image)
    cv2.waitKey()

  def __bgrToHexString(self, bgr):
    b = ""
    for channel in reversed(bgr):
      b = b + ("%X" % channel).zfill(2)
    return b

  def __sortedUniqueColors(self):
    return sorted(self.__uniqueColors(), key=lambda tup: tup[1][0])

  def __hsvToRgb(self, hsv):
    return hsv

  def __uniqueColors(self):
    image = cv2.imread(self.source)
    uniqueBgr = set()
    for line in image:
      for pixel in line:
        uniqueBgr.add(tuple(pixel))
    return [(bgr, self.__bgrToHsv(bgr)) for bgr in uniqueBgr]

  def __bgrToHsv(self, bgr):
    return cv2.cvtColor(numpy.array([[bgr]]), cv2.COLOR_BGR2HSV)[0][0]


if __name__ == "__main__":
  parser = argparse.ArgumentParser(description='')
  parser.add_argument('source', default='')
  parser.add_argument("--show", action="store_true")
  uc = UniqueColors()
  args = parser.parse_args(namespace=uc)
  uc.run()
