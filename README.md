# react-native-safe-area-emitter

Safe area event emitter of iOS for react-native

## Install

```sh
npm i react-native-safe-area-emitter
react-native link react-native-safe-area-emitter
```

## Usage

* `getSafeArea(reactTag)` get fafe area for a view
* `getRootSafeArea()` get safe area for root view
* `addListener(eventType, listener, context)` add event listener
* `addSafeAreaListener(listener, context)` add event listener for all view
* `addRootSafeAreaListener(listener, context)` add event listener for root view

## Example

```js
import {
  findNodeHandle
} from 'react-native';
import RNSafeArea from 'react-native-safe-area-emitter';

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

```
