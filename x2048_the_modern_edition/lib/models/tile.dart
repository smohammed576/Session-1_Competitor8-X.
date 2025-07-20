import 'package:flutter/material.dart';

class Tile{
  int x;
  int y;
  int value;

  Animation<double>? animatedX;
  Animation<double>? animatedY;
  Animation<int>? animatedValue;
  Animation<double>? scale;

  Tile(this.x, this.y, this.value){
    resetAnimations();
  }

  void resetAnimations(){
    animatedX = AlwaysStoppedAnimation(x.toDouble());
    animatedY = AlwaysStoppedAnimation(y.toDouble());
    animatedValue = AlwaysStoppedAnimation(value);
    scale = AlwaysStoppedAnimation(1);
  }

  void moveTo(Animation<double> parent, int x, int y){
    animatedX = Tween(
      begin: this.x.toDouble(),
      end: this.y.toDouble()
    ).animate(CurvedAnimation(parent: parent, curve: Interval(0, 0.5)));
    animatedY = Tween(
      begin: this.y.toDouble(),
      end: this.y.toDouble()
    ).animate(CurvedAnimation(parent: parent, curve: Interval(0, 0.5)));
  }

  void bounce(Animation<double> parent){
    scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 1.0),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 1.0)
    ]).animate(CurvedAnimation(parent: parent, curve: Interval(0.5, 1)));
  }

  void appear(Animation<double> parent){
    scale = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: parent, curve: Interval(0.5, 1)));
  }

  void changeNumber(Animation<double> parent, int newValue){
    animatedValue = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(value), weight: 0.01),
      TweenSequenceItem(tween: ConstantTween(newValue), weight: 0.99)
    ]).animate(CurvedAnimation(parent: parent, curve: Interval(0.5, 1)));
  }
}