declare module 'react-native-secure-storage' {
	export interface SecureStoreParams {
		keychainService: string;
		sharedPreferencesName: string;
	}

	export function getAllItems(store: SecureStoreParams): Promise<{ [key: string]: string }>;

	export function getItem(itemLabel: string, store: SecureStoreParams): Promise<string>;

	export function setItem(
		itemLabel: string,
		item: any,
		store: SecureStoreParams
	): Promise<void>;

	export function deleteItem(itemLabel: string, store: SecureStoreParams): Promise<void>;
}
