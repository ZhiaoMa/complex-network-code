close all; clear all; clc

stations=1:1:5;

flow=[487862,352345,491176,48684,431830];

recover=[0.9075,0.6961,0.9240,0.8180,0.8364];

[hAxes,hBar,hLine]=plotyy(stations,flow,stations,recover,'bar','plot');
