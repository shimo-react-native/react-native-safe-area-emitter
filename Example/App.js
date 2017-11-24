/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
  findNodeHandle
} from 'react-native';

import RNSafeArea from 'react-native-safe-area-emitter';

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' +
  'Cmd+D or shake for dev menu',
  android: 'Double tap R on your keyboard to reload,\n' +
  'Shake or press menu button for dev menu',
});

export default class App extends Component<{}> {

  constructor(props) {
    super(props);
    RNSafeArea.getRootSafeArea().then((result) => {
      console.log('SafeAreaExample', 'getRootSafeArea', result);
    });
  }

  componentDidMount() {
    const welcomReactTag = this.refs.welcome && findNodeHandle(this.refs.welcome);
    RNSafeArea.getSafeArea(welcomReactTag || 0).then((result) => {
      console.log('SafeAreaExample', 'getSafeArea', result);
    });

    this._rootSafeAreaListener = RNSafeArea.addRootSafeAreaListener((result) => {
      console.log('SafeAreaExample', 'listenRootSafeArea', result);
    });
    this._safeAreaListener = RNSafeArea.addSafeAreaListener((result) => {
      console.log('SafeAreaExample', 'listenSafeArea', result);
    });
  }

  componentWillUnmount() {
    this._safeAreaListener.remove();
    this._rootSafeAreaListener.remove();
  }

  _rootSafeAreaListener = null;
  _safeAreaListener = null;

  render() {
    return (
      <View style={styles.container}>
        <Text
          ref="welcome"
          style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit App.js
        </Text>
        <Text style={styles.instructions}>
          {instructions}
        </Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
