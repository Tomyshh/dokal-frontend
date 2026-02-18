# Connexion Google pour les patients

Ce document décrit les étapes pour activer la **connexion avec Google** pour les patients dans l’app Dokal (Flutter + Supabase).

## 1. Google Cloud Console

1. Aller sur [Google Cloud Console](https://console.cloud.google.com/) et créer ou sélectionner un projet.
2. Activer l’**API Google Identity** (ou “Google+ API” selon l’interface) pour le projet.
3. Aller dans **APIs & Services → Credentials** et créer **3 identifiants OAuth 2.0** :

   - **Application Web (type “Web application”)**  
     - Utilisé par Supabase pour vérifier les tokens.
     - **Authorized redirect URIs** : ajouter l’URL de callback Supabase :  
       `https://<VOTRE_PROJECT_REF>.supabase.co/auth/v1/callback`  
       (remplacer `<VOTRE_PROJECT_REF>` par l’ID de votre projet Supabase, visible dans l’URL du dashboard).
     - Noter le **Client ID** et le **Client Secret** (Web).

   - **Android**  
     - **Package name** : celui de votre app (ex. `com.example.dokal` → voir `applicationId` dans `android/app/build.gradle.kts`).
     - **SHA-1** : empreinte du keystore de debug ou release.  
       Pour debug : `cd android && ./gradlew signingReport` (ou `keytool -list -v -keystore ~/.android/debug.keystore`).
     - Noter le **Client ID (Android)**.

   - **iOS**  
     - **Bundle ID** : celui de votre app (ex. `com.example.dokal` → voir dans Xcode ou `ios/Runner/Info.plist`).
     - Noter le **Client ID (iOS)**.

4. **Écran de consentement OAuth**  
   Configurer au minimum les champs requis (nom du projet, email de support). Les scopes `openid`, `email`, `profile` sont en général déjà couverts par défaut.

## 2. Supabase Dashboard

1. Ouvrir le projet dans [Supabase Dashboard](https://supabase.com/dashboard).
2. **Authentication → Providers → Google** :
   - Activer **Enable Sign in with Google**.
   - **Client ID** : coller le **Client ID Web** (obligatoire).
   - **Client Secret** : coller le **Client Secret Web**.
   - Si vous utilisez plusieurs Client IDs (Web + Android + iOS), vous pouvez les indiquer dans le champ Client ID en les séparant par des virgules, **en mettant le Client ID Web en premier**.
   - Sur iOS, activer **Skip nonce check** si recommandé par la doc Supabase pour le flux natif.

3. **Authentication → URL Configuration**  
   - Vérifier que **Site URL** et les **Redirect URLs** correspondent à votre usage (pas obligatoire pour le flux natif avec `signInWithIdToken`).

## 3. Variables d’environnement (Flutter)

L’app lit les Client IDs Google via des **dart-defines** (ou un fichier passé à `--dart-define-from-file`).

À définir :

- **`GOOGLE_WEB_CLIENT_ID`** (obligatoire) : Client ID de l’application **Web** Google.
- **`GOOGLE_IOS_CLIENT_ID`** (optionnel mais recommandé sur iOS) : Client ID de l’application **iOS** Google.

Exemple dans un fichier `.env.prod` (à ne pas commiter) :

```env
SUPABASE_URL=https://xxxx.supabase.co
SUPABASE_ANON_KEY=eyJ...
GOOGLE_WEB_CLIENT_ID=xxxx.apps.googleusercontent.com
GOOGLE_IOS_CLIENT_ID=xxxx.apps.googleusercontent.com
```

Lancer l’app avec :

```bash
flutter run --dart-define-from-file=.env.prod
```

Ou en release :

```bash
flutter build apk --dart-define-from-file=.env.prod
flutter build ios --dart-define-from-file=.env.prod
```

Sans `GOOGLE_WEB_CLIENT_ID`, le bouton « Continuer avec Google » restera affiché mais une erreur « Google Sign-In non configuré » sera levée au clic.

## 4. Android

- Aucune modification supplémentaire obligatoire dans le projet actuel : `google_sign_in` gère la configuration.
- S’assurer que le **package name** et le **SHA-1** utilisés dans Google Cloud correspondent bien à l’app (debug et/ou release).

## 5. iOS

- Aucune modification de code supplémentaire requise pour le flux actuel.
- Dans Google Cloud, le **Bundle ID** doit correspondre à celui de `ios/Runner`.
- Si vous avez des problèmes de connexion, vérifier dans la doc Supabase / Google que **Skip nonce check** est cohérent avec votre flux.

## 6. Comportement dans l’app

- Sur l’écran de **connexion** (patients), un bouton **« Continuer avec Google »** a été ajouté.
- Au tap, l’app ouvre le flux Google (natif), récupère un **ID token**, puis appelle Supabase `signInWithIdToken(provider: OAuthProvider.google, ...)`.
- En cas de succès, la session Supabase est créée et l’utilisateur est redirigé comme après un login email/mot de passe (profil patient, complétion de profil si nécessaire, etc.).
- Les nouveaux utilisateurs créés via Google sont des comptes Supabase comme les autres ; vous pouvez réutiliser votre logique existante de profil patient (complétion, backend, etc.).

## 7. Dépannage

- **« Google Sign-In non configuré »** : `GOOGLE_WEB_CLIENT_ID` absent ou vide. Vérifier les dart-defines.
- **Erreur 12501 / « Sign in failed » sur Android** : souvent SHA-1 ou package name incorrects dans la console Google.
- **Erreur sur iOS** : vérifier Bundle ID et, si besoin, **Skip nonce check** dans Supabase.
- **« Connexion Google annulée »** : l’utilisateur a fermé l’écran Google sans valider ; pas d’action technique requise.

## Références

- [Supabase – Login with Google](https://supabase.com/docs/guides/auth/social-login/auth-google)
- [Supabase Flutter – Native Google sign in](https://supabase.com/docs/reference/dart/auth-signinwithidtoken)
- [google_sign_in (Flutter)](https://pub.dev/packages/google_sign_in)
