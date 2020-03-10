
# react-native-secure-storage

## Getting started

`$ npm install react-native-secure-storage --save`

### Mostly automatic installation 

`$ react-native link react-native-secure-storage`

If you use React Native version >= 0.60, need additionally run:

`$ cd ios && pod install && cd ..`

### Manual installation

#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-secure-storage` and add `RNSecureStorage.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNSecureStorage.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNSecureStoragePackage;` to the imports at the top of the file
  - Add `new RNSecureStoragePackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-secure-storage'
  	project(':react-native-secure-storage').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-secure-storage/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-secure-storage')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNSecureStorage.sln` in `node_modules/react-native-secure-storage/windows/RNSecureStorage.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Com.Reactlibrary.RNSecureStorage;` to the usings at the top of the file
  - Add `new RNSecureStoragePackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage

* getItem(String key, SecureStoreParams options)
* setItem(String key, String value, SecureStoreParams options)
* deleteItem(String key, SecureStoreParams options)
* getAllItems(SecureStoreParams options)

```typescript
interface SecureStoreParams {
    keychainService: string; //used for iOS
    sharedPreferencesName: string; //used for Android
}
```

### Example
```javascript
import RNSecureStorage from 'react-native-secure-storage';

const storeParams = {
  keychainService: 'accounts_example_app_ios',
  sharedPreferencesName: 'accounts_example_app_android',
}

async function RNSecureStorageExample () {
  await RNSecureStorage.setItem('sunny_day', '365', storeParams);
  const saveValue = await RNSecureStorage.getItem('sunny_day', storeParams);
  
  const allEntries = await RNSecureStorage.getAllItems(storeParams);
  //all Entries is an object with key as string and value as string;
  await RNSecureStorage.deleteItem('sunny_day', storeParams);
}
```
