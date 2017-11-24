/**
 * @providesModule RNSafeArea
 * @flow
 */

import { NativeModules, NativeEventEmitter } from 'react-native';

const { RNSafeArea } = NativeModules;
const safeAreaEventEmitter = RNSafeArea && new NativeEventEmitter(RNSafeArea);

function getRootSafeArea() {
  return RNSafeArea && RNSafeArea.getRootSafeArea && RNSafeArea.getRootSafeArea();
}

function getSafeArea(reactTag) {
  console.log('SafeArea', reactTag, RNSafeArea.getSafeArea);
  return RNSafeArea && RNSafeArea.getSafeArea && RNSafeArea.getSafeArea(reactTag);
}

function addListener(eventType: string, listener: Function, context: ?Object): EmitterSubscription {
  return safeAreaEventEmitter && safeAreaEventEmitter.addListener(eventType, listener, context);
}

function addSafeAreaListener(listener: Function, context: ?Object): EmitterSubscription {
  return safeAreaEventEmitter && safeAreaEventEmitter.addListener('SafeAreaEvent', listener, context);
}

function addRootSafeAreaListener(listener: Function, context: ?Object): EmitterSubscription {
  return safeAreaEventEmitter && safeAreaEventEmitter.addListener('RootSafeAreaEvent', listener, context);
}

export default {
  getSafeArea,
  getRootSafeArea,
  addListener,
  addSafeAreaListener,
  addRootSafeAreaListener
};
