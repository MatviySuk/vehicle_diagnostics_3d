import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/device/device_id_provider.dart';

/**********
 * ING: Exposes whether the device already has a stored session (device_id).
 * PT: Indica se o dispositivo já tem uma sessão guardada (device_id).
 ****/
final isAuthenticatedProvider = Provider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getString('device_id') != null;
});

/**********
 * ING: Manages authentication state — QR login, new session, and logout.
 *      Session is identified by a device_id persisted in shared preferences.
 * PT: Gere o estado de autenticação — login por QR, nova sessão e logout.
 *     A sessão é identificada por um device_id persistido nas preferências locais.
 ****/
class AuthNotifier extends Notifier<bool> {
  static const _key = 'device_id';
  static final _deviceIdRegex = RegExp(r'^device_\d{4}-\d{4}-\d{4}-\d{4}$');

  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getString(_key) != null;
  }

  /**********
   * ING: Validates the scanned QR value and saves it as the active device_id.
   *      Returns false if the format does not match device_XXXX-XXXX-XXXX-XXXX.
   * PT: Valida o valor lido pelo QR e guarda-o como device_id activo.
   *     Retorna falso se o formato não corresponder a device_XXXX-XXXX-XXXX-XXXX.
   ****/
  Future<bool> loginWithQr(String scannedValue) async {
    if (!_deviceIdRegex.hasMatch(scannedValue)) return false;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, scannedValue);
    state = true;
    return true;
  }

  /**********
   * ING: Clears the existing key so deviceIdProvider generates a fresh ID.
   * PT: Remove a chave existente para que o deviceIdProvider gere um novo ID.
   ****/
  Future<void> generateNewSession() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_key);
    ref.read(deviceIdProvider);
    state = true;
  }

  /**********
   * ING: Removes the device_id from storage, ending the current session.
   * PT: Remove o device_id do armazenamento, terminando a sessão actual.
   ****/
  Future<void> logout() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_key);
    state = false;
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, bool>(
  AuthNotifier.new,
);
