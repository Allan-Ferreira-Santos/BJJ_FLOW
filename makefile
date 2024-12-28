OS := $(shell uname)

install-flutter:
ifeq ($(OS),Windows_NT)
	choco install flutter
else
	brew tap leoafarias/fvm && brew install flutter
endif

install-fvm:
ifeq ($(OS),Windows_NT)
	choco install fvm
else
	brew tap leoafarias/fvm && brew install fvm
endif

check-fvm:
	@if ! command -v fvm >/dev/null 2>&1; then \
		$(MAKE) install-fvm; \
	fi

check-flutter:
	@if ! command -v flutter >/dev/null 2>&1; then \
		$(MAKE) install-flutter; \
	fi

config: check-fvm check-flutter

init:
	fvm use 3.27.1 && fvm flutter clean && fvm flutter pub get && make setup_secrets

setup_secrets: .copy_secrets
	@echo "[APP] Configurando secrets"

.copy_secrets:
	@echo "[APP] Copiando arquivos de segredos"
ifeq ($(OS),Windows)
	@if exist .secrets\firebase.json copy .secrets\firebase.json firebase.json
	@if exist .secrets\google-services.json copy .secrets\google-services.json android\app\google-services.json
	@if exist .secrets\firebase_options.dart copy .secrets\firebase_options.dart lib\firebase_options.dart
	@if exist .secrets\GoogleService-Info.plist copy .secrets\GoogleService-Info.plist ios/Runner/GoogleService-Info.plist
else
	@cp -v .secrets/firebase.json ./firebase.json
	@cp -v .secrets/google-services.json android/app/google-services.json
	@cp -v .secrets/firebase_options.dart lib/firebase_options.dart
	@cp -v .secrets/GoogleService-Info.plist ios/Runner/GoogleService-Info.plist
endif
	@echo "[APP] Configuração de segredos concluída"

	
