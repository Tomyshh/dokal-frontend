# Notifications Patient → Praticien (App mobile → CRM)

Ce document décrit ce qui doit être mis en place pour que les **praticiens** reçoivent des notifications (push navigateur + badges) lorsque les **patients** effectuent des actions depuis l'app mobile.

---

## 1. Événements à notifier

| Événement | Déclencheur (App mobile) | API appelée | Type notification |
|-----------|--------------------------|-------------|-------------------|
| **Annulation RDV** | Patient annule son rendez-vous | `PATCH /api/v1/appointments/{id}/cancel` | `appointment_cancelled` |
| **Nouveau message** | Patient envoie un message | `POST /api/v1/conversations/{id}/messages` | `new_message` |
| **Nouvelle réservation** | Patient confirme un booking | `POST /api/v1/bookings/confirm` | `appointment_request` |
| **Nouvel avis** | Patient laisse un avis | `POST /api/v1/reviews` (ou équivalent) | `review_received` |

---

## 2. Instructions pour le BACKEND

### 2.1 Envoi OneSignal aux praticiens

À chaque événement ci-dessus, le backend doit :

1. **Récupérer le `practitioner_id`** concerné (depuis l'appointment, la conversation, etc.)
2. **Récupérer le `user_id` (UUID Supabase)** du praticien via `practitioners.user_id` ou la table `profiles`
3. **Envoyer une notification OneSignal** avec :
   - `include_external_ids: [practitioner_user_id]` (UUID Supabase du praticien)
   - `contents`, `headings`, `data` (pour deep linking)

Exemple d'appel API OneSignal :

```http
POST https://api.onesignal.com/notifications
Authorization: Key YOUR_REST_API_KEY
Content-Type: application/json

{
  "app_id": "ONESIGNAL_APP_ID",
  "include_external_ids": ["uuid-supabase-du-praticien"],
  "target_channel": "push",
  "headings": { "en": "Nouveau message" },
  "contents": { "en": "Un patient vous a envoyé un message." },
  "data": {
    "type": "new_message",
    "conversation_id": "uuid-conversation",
    "appointment_id": "uuid-optional"
  }
}
```

### 2.2 Création des enregistrements `notifications`

Pour chaque événement, créer une ligne dans la table `notifications` (ou équivalent) avec :

- `user_id` = practitioner's user_id (UUID)
- `type` = `appointment_cancelled` | `new_message` | `appointment_request` | `review_received`
- `title`, `body`
- `data` = JSON avec `conversation_id`, `appointment_id`, etc. (pour deep linking)
- `is_read` = false

### 2.3 Endpoints notifications pour praticiens

Les endpoints existants doivent fonctionner pour les **praticiens** :

- `GET /api/v1/notifications` → retourne les notifications du user connecté (patient OU praticien)
- `GET /api/v1/notifications/unread-count` → compte des non lus
- `PATCH /api/v1/notifications/{id}/read`
- `PATCH /api/v1/notifications/read-all`
- `POST /api/v1/notifications/push-tokens` 
- `DELETE /api/v1/notifications/push-tokens`

**Important** : `POST /api/v1/notifications/push-tokens` doit accepter les **praticiens** (pas seulement les patients). Adapter le middleware : `requirePatient` → `requireAuth` ou ajouter `requirePractitioner` pour les deux rôles.

### 2.4 Points d’intégration backend

| Endpoint / événement | Action à ajouter |
|----------------------|------------------|
| `PATCH /api/v1/appointments/{id}/cancel` (patient) | Après annulation : créer notification + envoyer push OneSignal au praticien |
| `POST /api/v1/conversations/{id}/messages` | Après envoi du message : créer notification + envoyer push OneSignal au praticien |
| `POST /api/v1/bookings/confirm` (ou équivalent) | Après confirmation : créer notification + envoyer push OneSignal au praticien |
| `POST /api/v1/reviews` (ou équivalent) | Après création : créer notification + envoyer push OneSignal au praticien |

---

## 3. Instructions pour le FRONTEND CRM

### 3.1 OneSignal (push navigateur)

1. **Initialisation** au chargement du CRM (après login praticien) :
   - `OneSignal.init({ appId: ONESIGNAL_APP_ID })`
   - `OneSignal.login(practitioner_user_id)` avec l’UUID Supabase du praticien connecté

2. **Enregistrement du token push** :
   - Récupérer le subscription ID OneSignal (web)
   - Appeler `POST /api/v1/notifications/push-tokens` avec `{ token: subscriptionId, platform: "web" }`
   - À faire après connexion et après accord des permissions push du navigateur

3. **Déconnexion** :
   - `OneSignal.logout()` et suppression du token côté backend

### 3.2 Badges de notifications

1. **Compteur global** :
   - Appeler `GET /api/v1/notifications/unread-count` régulièrement (ex. toutes les 30 s ou au focus de l’onglet)
   - Afficher le `count` dans l’UI (icône cloche, badge, etc.)

2. **Compteurs par section** (optionnel) :
   - Messages non lus : via `GET /api/v1/conversations` si un champ `unread_count` existe
   - RDV en attente : via `GET /api/v1/crm/appointments` ou stats dashboard

### 3.3 Clic sur une notification (deep linking)

Lors du clic sur une notification push ou une entrée de la liste :

- Lire `data.type`, `data.conversation_id`, `data.appointment_id`
- Rediriger vers :
  - `/messages/{conversation_id}` si `type === "new_message"`
  - `/appointments/{appointment_id}` ou `/crm/appointments/{id}` si `type === "appointment_cancelled"` ou `appointment_request`
  - `/reviews` si `type === "review_received"`

### 3.4 Marquer comme lu

- Quand l’utilisateur ouvre une conversation : `PATCH /api/v1/conversations/{id}/read`
- Quand il consulte une notification : `PATCH /api/v1/notifications/{id}/read`
- Bouton « Tout marquer comme lu » : `PATCH /api/v1/notifications/read-all`

---

## 4. App mobile (patient) – Deep links CRM → App

L'app mobile gère désormais les **clics sur les notifications push** (CRM → patient) via un listener OneSignal.

### 4.1 Format `data` requis côté backend

Pour que les deep links fonctionnent, les notifications OneSignal envoyées aux **patients** doivent inclure un objet `data` avec :

| Champ | Type | Utilisation |
|-------|------|-------------|
| `type` | string | `new_message`, `appointment_cancelled`, `appointment_confirmed`, `appointment_request`, `appointment_reminder`, `review_received` |
| `conversation_id` | string (UUID) | Pour `new_message` → navigation vers `/messages/c/{id}` |
| `appointment_id` | string (UUID) | Pour les types RDV → navigation vers `/appointments/{id}` |

Exemple de payload OneSignal pour un patient :

```json
{
  "app_id": "ONESIGNAL_APP_ID",
  "include_external_ids": ["uuid-supabase-du-patient"],
  "target_channel": "push",
  "headings": { "en": "Nouveau message" },
  "contents": { "en": "Votre praticien vous a répondu." },
  "data": {
    "type": "new_message",
    "conversation_id": "uuid-conversation",
    "appointment_id": "uuid-optional"
  }
}
```

### 4.2 Mapping des types vers les routes

| Type | Route de destination |
|------|------------------------|
| `new_message` + `conversation_id` | `/messages/c/{conversation_id}` |
| `appointment_cancelled` / `appointment_confirmed` / `appointment_request` / `appointment_reminder` + `appointment_id` | `/appointments/{appointment_id}` |
| `review_received` | `/account` |
| Autre / données manquantes | `/home` |

---

## 5. App mobile (patient) – Actions

Aucune modification nécessaire côté app mobile pour ces notifications.

Les actions existantes déclenchent déjà les bons appels API :

- Annulation : `AppointmentDetailCubit.cancel()` → `PATCH /api/v1/appointments/{id}/cancel`
- Envoi de message : `ConversationCubit.send()` → `POST /api/v1/conversations/{id}/messages`

Le backend doit simplement réagir à ces appels en créant les notifications et en envoyant les push OneSignal aux praticiens.

---

## 6. Récapitulatif des rôles

| Composant | Rôle |
|-----------|------|
| **App mobile** | Patient : annule RDV, envoie message → appelle les API existantes. Gère les clics sur notifications (CRM → patient) via deep links. |
| **Backend** | Reçoit les appels, crée les notifications, envoie les push OneSignal (praticiens ET patients). Doit inclure `data` (type, conversation_id, appointment_id) pour les deep links. |
| **CRM** | Praticien : OneSignal.login(user_id), enregistre token web, affiche badges, gère le deep linking |
