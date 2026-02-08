# Dokal - Specifications Backend Completes

> Ce document contient **toutes les instructions** pour implementer le backend Supabase
> de l'application Dokal (prise de rendez-vous medicaux).
> Le frontend Flutter mobile est pret, la base de donnees SQL est definie dans `schema.sql`.
> Ce document precise **exactement** ce que le backend doit exposer.

---

## Table des matieres

1. [Vue d'ensemble de l'architecture](#1-vue-densemble-de-larchitecture)
2. [Configuration Supabase](#2-configuration-supabase)
3. [Schema de la base de donnees](#3-schema-de-la-base-de-donnees)
4. [Authentification](#4-authentification)
5. [API - Contrats par fonctionnalite](#5-api---contrats-par-fonctionnalite)
   - 5.1 [Profil utilisateur (Account)](#51-profil-utilisateur-account)
   - 5.2 [Proches / Relatives](#52-proches--relatives)
   - 5.3 [Moyens de paiement](#53-moyens-de-paiement)
   - 5.4 [Parametres utilisateur](#54-parametres-utilisateur)
   - 5.5 [Recherche de praticiens](#55-recherche-de-praticiens)
   - 5.6 [Profil praticien](#56-profil-praticien)
   - 5.7 [Creneaux disponibles](#57-creneaux-disponibles)
   - 5.8 [Rendez-vous (Booking)](#58-rendez-vous-booking)
   - 5.9 [Liste des rendez-vous (Appointments)](#59-liste-des-rendez-vous-appointments)
   - 5.10 [Messagerie](#510-messagerie)
   - 5.11 [Profil sante](#511-profil-sante)
   - 5.12 [Listes sante](#512-listes-sante)
   - 5.13 [Notifications](#513-notifications)
   - 5.14 [Avis / Reviews](#514-avis--reviews)
6. [CRM Docteur - Specifications completes](#6-crm-docteur---specifications-completes)
7. [Supabase Realtime](#7-supabase-realtime)
8. [Supabase Storage](#8-supabase-storage)
9. [Edge Functions](#9-edge-functions)
10. [Push Notifications](#10-push-notifications)
11. [Seed Data](#11-seed-data)
12. [Securite & Bonnes pratiques](#12-securite--bonnes-pratiques)

---

## 1. Vue d'ensemble de l'architecture

```
┌─────────────────────────────────────────────────────────┐
│                    CLIENTS                              │
│                                                         │
│   ┌──────────────┐        ┌──────────────────────┐      │
│   │ App Mobile   │        │ CRM Docteur (Web)    │      │
│   │ Flutter      │        │ React / Next.js      │      │
│   │ (Patient)    │        │ (Praticien)          │      │
│   └──────┬───────┘        └──────────┬───────────┘      │
│          │                           │                  │
└──────────┼───────────────────────────┼──────────────────┘
           │    Supabase Client SDK    │
           │    (supabase-flutter /    │
           │     supabase-js)         │
           ▼                           ▼
┌─────────────────────────────────────────────────────────┐
│                    SUPABASE                             │
│                                                         │
│   ┌──────────────────────────────────────────────┐      │
│   │  Auth (GoTrue)                               │      │
│   │  - Email/Password signup + login             │      │
│   │  - Session JWT management                    │      │
│   │  - Password reset                            │      │
│   └──────────────────────────────────────────────┘      │
│                                                         │
│   ┌──────────────────────────────────────────────┐      │
│   │  PostgREST API (auto-generated)              │      │
│   │  - CRUD on all tables                        │      │
│   │  - RPC functions                             │      │
│   │  - RLS enforced                              │      │
│   └──────────────────────────────────────────────┘      │
│                                                         │
│   ┌──────────────────────────────────────────────┐      │
│   │  Realtime                                    │      │
│   │  - Postgres Changes (messages, appointments) │      │
│   │  - Presence (online status)                  │      │
│   └──────────────────────────────────────────────┘      │
│                                                         │
│   ┌──────────────────────────────────────────────┐      │
│   │  Edge Functions (Deno)                       │      │
│   │  - Complex business logic                    │      │
│   │  - Push notifications (FCM/APNs)             │      │
│   │  - Stripe integration                        │      │
│   └──────────────────────────────────────────────┘      │
│                                                         │
│   ┌──────────────────────────────────────────────┐      │
│   │  Storage                                     │      │
│   │  - Avatars                                   │      │
│   │  - Message attachments                       │      │
│   └──────────────────────────────────────────────┘      │
│                                                         │
│   ┌──────────────────────────────────────────────┐      │
│   │  PostgreSQL                                  │      │
│   │  - schema.sql (20+ tables, RLS, triggers)    │      │
│   └──────────────────────────────────────────────┘      │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Approche :** Le frontend Flutter utilise le SDK Supabase directement (pas de REST API custom).
Toute la securite repose sur les **Row Level Security (RLS) policies** definies dans `schema.sql`.
Les **Edge Functions** ne sont necessaires que pour la logique metier complexe (push notifications, paiements).

---

## 2. Configuration Supabase

### 2.1 Variables d'environnement attendues par le frontend

Le frontend Flutter lit ces variables au demarrage (via `--dart-define` ou `.env.local`) :

```
SUPABASE_URL=https://<project-ref>.supabase.co
SUPABASE_ANON_KEY=eyJ...
```

### 2.2 Initialisation Supabase

Le frontend initialise Supabase avec :
```dart
await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
```

Le backend doit s'assurer que :
- Le projet Supabase est cree
- `schema.sql` est execute dans le SQL Editor
- L'authentification email/password est activee
- Le Realtime est active sur les tables `messages`, `appointments`, `notifications`
- Le Storage est configure (buckets `avatars`, `attachments`)

---

## 3. Schema de la base de donnees

**Fichier reference : `schema.sql`** (dans le meme dossier que ce document).

Executer le fichier `schema.sql` dans le SQL Editor de Supabase. Il cree :

### Tables (22 tables)

| Table | Description |
|-------|-------------|
| `profiles` | Extension de `auth.users` (nom, email, role, ville, etc.) |
| `user_settings` | Preferences (notifications, rappels, langue) |
| `specialties` | Catalogue des specialites medicales |
| `practitioners` | Profils docteurs (specialite, adresse, langues, etc.) |
| `practitioner_weekly_schedule` | Horaires hebdomadaires recurrents |
| `practitioner_schedule_overrides` | Exceptions (vacances, jours speciaux) |
| `appointment_reasons` | Motifs de consultation (globaux ou par praticien) |
| `appointment_instructions` | Instructions pre-rendez-vous par praticien |
| `relatives` | Proches du patient (enfants, parents, etc.) |
| `health_profiles` | Dossier medical (teudat zehut, kupat holim, etc.) |
| `health_conditions` | Conditions medicales |
| `health_medications` | Medicaments |
| `health_allergies` | Allergies |
| `health_vaccinations` | Vaccinations |
| `appointments` | Rendez-vous (coeur du systeme) |
| `appointment_questionnaires` | Questionnaires lies aux RDV |
| `conversations` | Conversations patient/praticien |
| `messages` | Messages individuels |
| `payment_methods` | Moyens de paiement (tokenises) |
| `reviews` | Avis patients (1 par RDV) |
| `notifications` | Notifications in-app |
| `audit_log` | Journal des actions CRM |

### ENUMs

| Enum | Valeurs |
|------|---------|
| `user_role` | `patient`, `practitioner`, `admin` |
| `sex_type` | `male`, `female`, `other` |
| `relation_type` | `child`, `parent`, `spouse`, `sibling`, `other` |
| `appointment_status` | `pending`, `confirmed`, `cancelled_by_patient`, `cancelled_by_practitioner`, `completed`, `no_show` |
| `message_type` | `text`, `image`, `file`, `system` |
| `notification_type` | `appointment_request`, `appointment_confirmed`, `appointment_cancelled`, `appointment_reminder`, `new_message`, `review_received` |

### Triggers automatiques (deja dans schema.sql)

1. **`on_auth_user_created`** : A l'inscription, cree automatiquement `profiles` + `user_settings`
2. **`appointments_after_insert`** : Cree une notification `appointment_request` pour le praticien + cree la conversation
3. **`appointments_after_update`** : Quand le statut change, cree des notifications pour les deux parties + set les timestamps (`confirmed_at`, `cancelled_at`, `completed_at`)
4. **`messages_after_insert`** : Met a jour `conversations.last_message_at` + cree une notification `new_message`
5. **`*_set_updated_at`** : Met a jour `updated_at` automatiquement sur toutes les tables concernees

### Fonctions RPC (deja dans schema.sql)

1. **`get_practitioner_appointment_stats(practitioner, from_date, to_date)`** : Stats CRM (pending, confirmed, cancelled, completed, no_show)
2. **`get_practitioner_available_slots(practitioner, from_date, to_date)`** : Genere les creneaux disponibles (schedule - overrides - booked)

---

## 4. Authentification

L'authentification est **deja implementee** dans le frontend via Supabase Auth. Le backend doit simplement s'assurer que :

### 4.1 Configuration Supabase Auth

- **Email/Password** : Active
- **Confirmation email** : Active (le frontend a une page `/verify-email`)
- **Password reset** : Active (le frontend a une page `/forgot-password`)
- **Minimum password length** : 6 caracteres

### 4.2 Metadata utilisateur a l'inscription

Le frontend envoie ces metadata lors du `signUp` :

```dart
await supabase.auth.signUp(
  email: email,
  password: password,
  data: {
    'first_name': firstName,
    'last_name': lastName,
  },
);
```

Le trigger `handle_new_user()` dans `schema.sql` lit ces metadata et cree le profil automatiquement.

### 4.3 Operations Auth attendues

| Operation | Methode Supabase |
|-----------|------------------|
| Inscription | `supabase.auth.signUp(email, password, data)` |
| Connexion | `supabase.auth.signInWithPassword(email, password)` |
| Deconnexion | `supabase.auth.signOut()` |
| Session courante | `supabase.auth.currentSession` |
| Reset mot de passe | `supabase.auth.resetPasswordForEmail(email)` |
| Renvoyer confirmation | `supabase.auth.resend(type: OtpType.signup, email)` |

**Rien a implementer cote backend** - Supabase Auth gere tout. Le trigger dans `schema.sql` gere la creation du profil.

---

## 5. API - Contrats par fonctionnalite

> **Convention :** Le frontend utilise le SDK Supabase directement.
> Chaque section ci-dessous decrit les queries Supabase exactes que le frontend va executer.
> Le backend doit s'assurer que les RLS policies et les donnees sont en place.

### 5.1 Profil utilisateur (Account)

#### `getProfile()` - Recuperer le profil de l'utilisateur connecte

```dart
final response = await supabase
  .from('profiles')
  .select('id, first_name, last_name, email, phone, date_of_birth, sex, city, avatar_url, role')
  .eq('id', supabase.auth.currentUser!.id)
  .single();
```

**Reponse attendue (JSON) :**
```json
{
  "id": "uuid",
  "first_name": "David",
  "last_name": "Cohen",
  "email": "david@example.com",
  "phone": "+972-50-1234567",
  "date_of_birth": "1990-05-15",
  "sex": "male",
  "city": "Tel Aviv",
  "avatar_url": "https://...supabase.co/storage/v1/object/public/avatars/...",
  "role": "patient"
}
```

#### `updateProfile()` - Mettre a jour le profil

```dart
await supabase
  .from('profiles')
  .update({
    'first_name': firstName,
    'last_name': lastName,
    'phone': phone,
    'city': city,
    'date_of_birth': dateOfBirth,
    'sex': sex,
  })
  .eq('id', supabase.auth.currentUser!.id);
```

---

### 5.2 Proches / Relatives

#### `listRelatives()` - Lister les proches

```dart
final response = await supabase
  .from('relatives')
  .select('id, first_name, last_name, relation, date_of_birth')
  .eq('user_id', supabase.auth.currentUser!.id)
  .order('created_at');
```

**Reponse attendue (JSON) :**
```json
[
  {
    "id": "uuid",
    "first_name": "Sarah",
    "last_name": "Cohen",
    "relation": "child",
    "date_of_birth": "2018-03-20"
  }
]
```

**Mapping vers l'entite frontend :**
- `name` = `"$first_name $last_name"`
- `label` = relation traduite + annee de naissance (ex: "Enfant - 2018")

#### `addRelative()` - Ajouter un proche

```dart
await supabase.from('relatives').insert({
  'user_id': supabase.auth.currentUser!.id,
  'first_name': firstName,
  'last_name': lastName,
  'relation': relationType,  // 'child' | 'parent' | 'spouse' | 'sibling' | 'other'
  'date_of_birth': dateOfBirth,
});
```

#### `deleteRelative()` - Supprimer un proche

```dart
await supabase.from('relatives').delete().eq('id', relativeId);
```

---

### 5.3 Moyens de paiement

#### `listPaymentMethods()` - Lister les moyens de paiement

```dart
final response = await supabase
  .from('payment_methods')
  .select('id, brand, last4, expiry_month, expiry_year, is_default')
  .eq('user_id', supabase.auth.currentUser!.id)
  .order('created_at');
```

**Mapping vers l'entite frontend :**
- `brandLabel` = `brand` (ex: "Visa")
- `last4` = `last4`
- `expiry` = `"$expiry_month/$expiry_year"` (ex: "12/26")

#### `addPaymentMethod()` - Ajouter un moyen de paiement

> **Note :** Necessite une **Edge Function** pour l'integration Stripe/payment provider.
> Le frontend enverra le token de carte, l'Edge Function le traitera et inserera dans `payment_methods`.

```dart
// Via Edge Function
final response = await supabase.functions.invoke('add-payment-method', body: {
  'card_token': stripeToken,
});
```

---

### 5.4 Parametres utilisateur

#### `getSettings()` - Recuperer les parametres

```dart
final response = await supabase
  .from('user_settings')
  .select('notifications_enabled, reminders_enabled, locale')
  .eq('user_id', supabase.auth.currentUser!.id)
  .single();
```

#### `saveSettings()` - Sauvegarder les parametres

```dart
await supabase
  .from('user_settings')
  .update({
    'notifications_enabled': notificationsEnabled,
    'reminders_enabled': remindersEnabled,
  })
  .eq('user_id', supabase.auth.currentUser!.id);
```

---

### 5.5 Recherche de praticiens

#### `search(query)` - Rechercher des praticiens

```dart
final response = await supabase
  .from('practitioners')
  .select('''
    id,
    address_line, zip_code, city,
    sector, latitude, longitude,
    about, languages, education, years_of_experience,
    avatar_url,
    is_accepting_new_patients,
    profiles!inner(first_name, last_name),
    specialties!inner(name, name_fr, name_he)
  ''')
  .eq('is_active', true)
  .or('profiles.first_name.ilike.%$query%,profiles.last_name.ilike.%$query%,specialties.name.ilike.%$query%,specialties.name_fr.ilike.%$query%,city.ilike.%$query%')
  .limit(50);
```

**Mapping vers l'entite frontend `PractitionerSearchResult` :**
- `id` = `id`
- `name` = `"${profiles.first_name} ${profiles.last_name}"`
  - Prefixe "Dr. " ou equivalent
- `specialty` = `specialties.name_fr` (ou `name` / `name_he` selon la locale)
- `address` = `"$address_line, $city"`
- `sector` = `sector`
- `nextAvailabilityLabel` = calcule via `get_practitioner_available_slots()` (voir 5.7)
- `distanceLabel` = calcule cote client a partir de `latitude`, `longitude`
- `distanceKm` = calcule cote client
- `availabilityOrder` = 0 (today), 1 (tomorrow), 2 (this week), 3+ (later)

**Important :** La recherche doit supporter :
- Recherche par nom du praticien
- Recherche par specialite
- Recherche par ville
- Tri par disponibilite (prochain creneau disponible)
- Tri par distance (si geo-localisation disponible)

---

### 5.6 Profil praticien

#### `getById(id)` - Recuperer le profil d'un praticien

```dart
final response = await supabase
  .from('practitioners')
  .select('''
    id,
    address_line, zip_code, city,
    sector, latitude, longitude,
    about, phone, email,
    languages, education, years_of_experience,
    avatar_url,
    consultation_duration_minutes,
    is_accepting_new_patients,
    profiles!inner(first_name, last_name, avatar_url),
    specialties(name, name_fr, name_he)
  ''')
  .eq('id', id)
  .single();
```

**Puis, recuperer les prochaines disponibilites :**
```dart
final slots = await supabase.rpc('get_practitioner_available_slots', params: {
  'practitioner': id,
  'from_date': today.toIso8601String(),
  'to_date': today.add(Duration(days: 14)).toIso8601String(),
});
```

**Puis, recuperer les instructions :**
```dart
final instructions = await supabase
  .from('appointment_instructions')
  .select('id, title, content, sort_order')
  .eq('practitioner_id', id)
  .eq('is_active', true)
  .order('sort_order');
```

**Puis, recuperer les avis :**
```dart
final reviews = await supabase
  .from('reviews')
  .select('id, rating, comment, practitioner_reply, created_at, profiles!patient_id(first_name, last_name)')
  .eq('practitioner_id', id)
  .order('created_at', ascending: false)
  .limit(10);
```

**Mapping vers l'entite frontend `PractitionerProfile` :**
- `id` = `id`
- `name` = `"Dr. ${profiles.first_name} ${profiles.last_name}"`
- `specialty` = `specialties.name_fr`
- `address` = `"$address_line, $zip_code $city"`
- `about` = `about`
- `nextAvailabilities` = liste formatee des prochains slots (ex: `["Lun. 3 fev. 11:00", "Mar. 4 fev. 14:00"]`)
- `avatarUrl` = `profiles.avatar_url` ou `avatar_url`
- `sector` = `sector`
- `phone` = `phone`
- `email` = `email`
- `languages` = `languages`
- `education` = `education`
- `yearsOfExperience` = `years_of_experience`

---

### 5.7 Creneaux disponibles

#### Via la fonction RPC `get_practitioner_available_slots`

```dart
final slots = await supabase.rpc('get_practitioner_available_slots', params: {
  'practitioner': practitionerId,
  'from_date': fromDate,  // ISO date string
  'to_date': toDate,      // ISO date string
});
```

**Reponse :**
```json
[
  {"slot_date": "2026-02-10", "slot_start": "09:00:00", "slot_end": "09:30:00"},
  {"slot_date": "2026-02-10", "slot_start": "09:30:00", "slot_end": "10:00:00"},
  {"slot_date": "2026-02-10", "slot_start": "10:00:00", "slot_end": "10:30:00"},
  {"slot_date": "2026-02-11", "slot_start": "14:00:00", "slot_end": "14:30:00"}
]
```

**Logique (deja dans schema.sql) :**
1. Genere les jours dans la plage `from_date` - `to_date`
2. Pour chaque jour, prend le `practitioner_weekly_schedule` correspondant au `day_of_week`
3. Applique les `schedule_overrides` (jour ferme, horaires speciaux)
4. Genere les slots selon `slot_duration_minutes`
5. Exclut les slots deja reserves (status `pending` ou `confirmed`)

---

### 5.8 Rendez-vous (Booking)

#### `confirm()` - Creer un nouveau rendez-vous

Le frontend collecte ces donnees pendant le flow de booking :

| Champ | Source | Description |
|-------|--------|-------------|
| `practitioner_id` | Route param | UUID du praticien |
| `reason` | Step 1 | Motif selectionne (texte ou `reason_id`) |
| `patient_label` | Step 2 | Nom du patient (soi-meme ou proche) |
| `slot` | Step 4 | Date + heure selectionnees |
| `address_line` | Step 5 | Adresse du patient |
| `zip_code` | Step 5 | Code postal |
| `city` | Step 5 | Ville |
| `visited_before` | Step 5 | Boolean |

**Query Supabase :**

```dart
// Determine le relative_id si le patient selectionne est un proche
String? relativeId;
if (patientLabel != currentUserName) {
  final relative = await supabase
    .from('relatives')
    .select('id')
    .eq('user_id', userId)
    .ilike('first_name', patientFirstName)
    .maybeSingle();
  relativeId = relative?['id'];
}

// Trouver le reason_id correspondant
final reason = await supabase
  .from('appointment_reasons')
  .select('id')
  .or('practitioner_id.eq.$practitionerId,practitioner_id.is.null')
  .ilike('label_fr', reasonLabel)
  .limit(1)
  .maybeSingle();

// Inserer le rendez-vous
final response = await supabase
  .from('appointments')
  .insert({
    'patient_id': supabase.auth.currentUser!.id,
    'practitioner_id': practitionerId,
    'relative_id': relativeId,
    'reason_id': reason?['id'],
    'appointment_date': slotDate,        // ex: '2026-02-10'
    'start_time': slotStartTime,         // ex: '11:00:00'
    'end_time': slotEndTime,             // ex: '11:30:00'
    'status': 'pending',
    'patient_address_line': addressLine,
    'patient_zip_code': zipCode,
    'patient_city': city,
    'visited_before': visitedBefore,
  })
  .select('id')
  .single();

return response['id']; // UUID du rendez-vous cree
```

**Effets automatiques (triggers dans schema.sql) :**
1. Le trigger `appointments_after_insert` cree une notification `appointment_request` pour le praticien
2. Le trigger cree aussi une conversation entre le patient et le praticien (si elle n'existe pas deja)

**Le statut initial est `pending`.** Le praticien doit confirmer via le CRM (voir section 6).

---

### 5.9 Liste des rendez-vous (Appointments)

#### `listUpcoming()` - Rendez-vous a venir

```dart
final response = await supabase
  .from('appointments')
  .select('''
    id, appointment_date, start_time, end_time,
    status, visited_before,
    patient_address_line, patient_zip_code, patient_city,
    practitioner_notes,
    practitioners!inner(
      id,
      profiles!inner(first_name, last_name, avatar_url),
      specialties(name, name_fr)
    ),
    appointment_reasons(label, label_fr),
    relatives(first_name, last_name)
  ''')
  .eq('patient_id', supabase.auth.currentUser!.id)
  .gte('appointment_date', today)
  .inFilter('status', ['pending', 'confirmed'])
  .order('appointment_date')
  .order('start_time');
```

**Mapping vers l'entite frontend `Appointment` :**
- `id` = `id`
- `practitionerId` = `practitioners.id`
- `dateLabel` = formatage de `appointment_date` (ex: "Lundi 10 fevrier 2026")
- `timeLabel` = formatage de `start_time` (ex: "11:00")
- `practitionerName` = `"Dr. ${practitioners.profiles.first_name} ${practitioners.profiles.last_name}"`
- `specialty` = `practitioners.specialties.name_fr`
- `reason` = `appointment_reasons.label_fr` ou `appointment_reasons.label`
- `isPast` = `false`
- `patientName` = `relatives.first_name + " " + relatives.last_name` (ou null si pour soi-meme)
- `address` = `"$patient_address_line, $patient_city"`
- `avatarUrl` = `practitioners.profiles.avatar_url`

#### `listPast()` - Rendez-vous passes

```dart
final response = await supabase
  .from('appointments')
  .select(/* meme select que ci-dessus */)
  .eq('patient_id', supabase.auth.currentUser!.id)
  .or('appointment_date.lt.$today,status.in.(completed,no_show,cancelled_by_patient,cancelled_by_practitioner)')
  .order('appointment_date', ascending: false)
  .order('start_time', ascending: false)
  .limit(50);
```

#### `getById(id)` - Detail d'un rendez-vous

```dart
final response = await supabase
  .from('appointments')
  .select(/* meme select + questionnaire + instructions */)
  .eq('id', appointmentId)
  .single();
```

#### `cancel(id)` - Annuler un rendez-vous (par le patient)

```dart
await supabase
  .from('appointments')
  .update({
    'status': 'cancelled_by_patient',
    'cancellation_reason': reason,  // optionnel
  })
  .eq('id', appointmentId)
  .eq('patient_id', supabase.auth.currentUser!.id);
```

**Effet automatique :** Le trigger `appointments_after_update` cree des notifications pour les deux parties.

---

### 5.10 Messagerie

#### `listConversations()` - Lister les conversations

```dart
final response = await supabase
  .from('conversations')
  .select('''
    id, last_message_at,
    practitioners!inner(
      id,
      profiles!inner(first_name, last_name, avatar_url)
    ),
    appointments(id, appointment_date, start_time, status)
  ''')
  .eq('patient_id', supabase.auth.currentUser!.id)
  .order('last_message_at', ascending: false, nullsFirst: false);
```

**Puis, pour chaque conversation, recuperer le dernier message et le nombre de non-lus :**

```dart
// Option 1: Vue SQL (recommandee pour la performance)
// Creer une vue ou une fonction RPC qui retourne tout en un seul appel

// Option 2: Query separee par conversation
final lastMsg = await supabase
  .from('messages')
  .select('content, created_at')
  .eq('conversation_id', conversationId)
  .order('created_at', ascending: false)
  .limit(1)
  .maybeSingle();

final unreadCount = await supabase
  .from('messages')
  .select('id', const FetchOptions(count: CountOption.exact, head: true))
  .eq('conversation_id', conversationId)
  .eq('recipient_id', supabase.auth.currentUser!.id)
  .eq('is_read', false);
```

**Mapping vers `ConversationPreview` :**
- `id` = `id`
- `name` = `"Dr. ${practitioners.profiles.first_name} ${practitioners.profiles.last_name}"`
- `lastMessage` = `messages[0].content`
- `timeAgo` = calcul relatif depuis `last_message_at`
- `unreadCount` = count des messages non lus
- `isOnline` = via Supabase Presence (voir section 7)
- `avatarColorValue` = hash du nom du praticien
- `appointment` = si `appointments` existe, mapper vers `ConversationAppointmentPreview`

#### `getConversationMessages(conversationId)` - Messages d'une conversation

```dart
final response = await supabase
  .from('messages')
  .select('id, sender_id, content, message_type, is_read, created_at')
  .eq('conversation_id', conversationId)
  .order('created_at')
  .limit(100);
```

**Mapping vers `ChatMessage` :**
- `fromMe` = `sender_id == supabase.auth.currentUser!.id`
- `text` = `content`

#### `sendMessage()` - Envoyer un message

```dart
await supabase.from('messages').insert({
  'conversation_id': conversationId,
  'sender_id': supabase.auth.currentUser!.id,
  'recipient_id': recipientId,
  'content': text,
  'message_type': 'text',
});
```

**Pour determiner `recipient_id` :**
```dart
final conv = await supabase
  .from('conversations')
  .select('patient_id, practitioner_id')
  .eq('id', conversationId)
  .single();

final recipientId = conv['patient_id'] == supabase.auth.currentUser!.id
  ? conv['practitioner_id']
  : conv['patient_id'];
```

#### `markAsRead()` - Marquer les messages comme lus

```dart
await supabase
  .from('messages')
  .update({'is_read': true, 'read_at': DateTime.now().toIso8601String()})
  .eq('conversation_id', conversationId)
  .eq('recipient_id', supabase.auth.currentUser!.id)
  .eq('is_read', false);
```

---

### 5.11 Profil sante

#### `getHealthProfile()` - Recuperer le profil sante

```dart
final response = await supabase
  .from('health_profiles')
  .select('*')
  .eq('user_id', supabase.auth.currentUser!.id)
  .maybeSingle();
```

**Mapping vers `HealthProfile` :**
- `fullName` = depuis `profiles` (first_name + last_name)
- `teudatZehut` = `teudat_zehut_encrypted` (dechiffre cote client ou via Edge Function)
- `dateOfBirth` = `date_of_birth`
- `sex` = `sex`
- `kupatHolim` = `kupat_holim`
- `kupatMemberId` = `kupat_member_id`
- `familyDoctorName` = `family_doctor_name`
- `bloodType` = `blood_type`
- `emergencyContactName` = `emergency_contact_name`
- `emergencyContactPhone` = `emergency_contact_phone`

#### `saveHealthProfile()` - Sauvegarder le profil sante

```dart
await supabase.from('health_profiles').upsert({
  'user_id': supabase.auth.currentUser!.id,
  'date_of_birth': dateOfBirth,
  'sex': sex,
  'blood_type': bloodType,
  'kupat_holim': kupatHolim,
  'kupat_member_id': kupatMemberId,
  'family_doctor_name': familyDoctorName,
  'emergency_contact_name': emergencyContactName,
  'emergency_contact_phone': emergencyContactPhone,
  // teudat_zehut_encrypted doit etre chiffre avant insertion
});
```

**Important :** Le `teudat_zehut` (numero d'identite israelien) doit etre chiffre. Utiliser `pgcrypto` via une Edge Function ou cote client.

---

### 5.12 Listes sante

Les 4 listes sante (`conditions`, `medications`, `allergies`, `vaccinations`) suivent le meme pattern.

#### `list(type)` - Lister les items

```dart
// type = 'health_conditions' | 'health_medications' | 'health_allergies' | 'health_vaccinations'
final response = await supabase
  .from(tableName)
  .select('id, name')
  .eq('user_id', supabase.auth.currentUser!.id)
  .order('created_at');
```

**Mapping vers `HealthItem` :**
- `id` = `id`
- `label` = `name`

#### `add(type, name)` - Ajouter un item

```dart
await supabase.from(tableName).insert({
  'user_id': supabase.auth.currentUser!.id,
  'name': name,
  // champs optionnels selon le type
});
```

#### `delete(type, id)` - Supprimer un item

```dart
await supabase.from(tableName).delete().eq('id', itemId);
```

---

### 5.13 Notifications

#### `listNotifications()` - Lister les notifications

```dart
final response = await supabase
  .from('notifications')
  .select('id, type, title, body, data, is_read, created_at')
  .eq('user_id', supabase.auth.currentUser!.id)
  .order('created_at', ascending: false)
  .limit(50);
```

#### `markAsRead(id)` - Marquer comme lue

```dart
await supabase
  .from('notifications')
  .update({'is_read': true})
  .eq('id', notificationId);
```

#### `markAllAsRead()` - Tout marquer comme lu

```dart
await supabase
  .from('notifications')
  .update({'is_read': true})
  .eq('user_id', supabase.auth.currentUser!.id)
  .eq('is_read', false);
```

#### `getUnreadCount()` - Nombre de non-lues

```dart
final count = await supabase
  .from('notifications')
  .select('id', const FetchOptions(count: CountOption.exact, head: true))
  .eq('user_id', supabase.auth.currentUser!.id)
  .eq('is_read', false);
```

---

### 5.14 Avis / Reviews

#### `listByPractitioner(practitionerId)` - Avis d'un praticien

```dart
final response = await supabase
  .from('reviews')
  .select('id, rating, comment, practitioner_reply, created_at, profiles!patient_id(first_name)')
  .eq('practitioner_id', practitionerId)
  .order('created_at', ascending: false)
  .limit(20);
```

#### `create()` - Laisser un avis (patient, apres RDV termine)

```dart
await supabase.from('reviews').insert({
  'appointment_id': appointmentId,
  'patient_id': supabase.auth.currentUser!.id,
  'practitioner_id': practitionerId,
  'rating': rating,  // 1-5
  'comment': comment,
});
```

**Note :** La RLS policy ne permet l'insertion que si le RDV est `completed` ou `no_show`.

#### `reply()` - Repondre a un avis (praticien)

```dart
await supabase
  .from('reviews')
  .update({'practitioner_reply': reply})
  .eq('id', reviewId);
```

---

## 6. CRM Docteur - Specifications completes

Le CRM est une **application web separee** (React/Next.js recommande) qui utilise le meme projet Supabase.
Le praticien se connecte avec le meme systeme auth (email/password) mais a le role `practitioner` dans `profiles`.

### 6.1 Authentification CRM

Meme systeme que l'app mobile. Le praticien se connecte et le frontend CRM verifie :

```js
const { data: profile } = await supabase
  .from('profiles')
  .select('role')
  .eq('id', user.id)
  .single();

if (profile.role !== 'practitioner') {
  // Rediriger vers une page d'erreur
}
```

### 6.2 Dashboard CRM

#### Stats du jour / de la semaine / du mois

```js
const { data: stats } = await supabase.rpc('get_practitioner_appointment_stats', {
  practitioner: user.id,
  from_date: '2026-02-08',
  to_date: '2026-02-08',  // aujourd'hui pour stats du jour
});
// Retourne: { pending, confirmed, cancelled, completed, no_show }
```

#### Liste des RDV du jour

```js
const { data: todayAppointments } = await supabase
  .from('appointments')
  .select(`
    id, appointment_date, start_time, end_time,
    status, visited_before, practitioner_notes,
    patient_address_line, patient_zip_code, patient_city,
    cancellation_reason,
    profiles!patient_id(id, first_name, last_name, email, phone, avatar_url),
    appointment_reasons(label, label_fr),
    relatives(first_name, last_name, relation)
  `)
  .eq('practitioner_id', user.id)
  .eq('appointment_date', today)
  .order('start_time');
```

#### Rendez-vous en attente (a confirmer)

```js
const { data: pendingAppointments } = await supabase
  .from('appointments')
  .select(`/* meme select */`)
  .eq('practitioner_id', user.id)
  .eq('status', 'pending')
  .order('appointment_date')
  .order('start_time');
```

### 6.3 Actions CRM sur les rendez-vous

#### Confirmer un rendez-vous

```js
await supabase
  .from('appointments')
  .update({ status: 'confirmed' })
  .eq('id', appointmentId)
  .eq('practitioner_id', user.id);

// Log l'action
await supabase.from('audit_log').insert({
  actor_id: user.id,
  action: 'appointment.confirmed',
  entity_type: 'appointment',
  entity_id: appointmentId,
  metadata: {},
});
```

**Effets automatiques (trigger) :** Notification `appointment_confirmed` envoyee au patient.

#### Refuser / Annuler un rendez-vous

```js
await supabase
  .from('appointments')
  .update({
    status: 'cancelled_by_practitioner',
    cancellation_reason: reason,
  })
  .eq('id', appointmentId)
  .eq('practitioner_id', user.id);

await supabase.from('audit_log').insert({
  actor_id: user.id,
  action: 'appointment.cancelled_by_practitioner',
  entity_type: 'appointment',
  entity_id: appointmentId,
  metadata: { reason },
});
```

#### Marquer comme termine

```js
await supabase
  .from('appointments')
  .update({
    status: 'completed',
    practitioner_notes: notes,
  })
  .eq('id', appointmentId)
  .eq('practitioner_id', user.id);

await supabase.from('audit_log').insert({
  actor_id: user.id,
  action: 'appointment.completed',
  entity_type: 'appointment',
  entity_id: appointmentId,
  metadata: { notes },
});
```

#### Marquer comme no-show

```js
await supabase
  .from('appointments')
  .update({ status: 'no_show' })
  .eq('id', appointmentId)
  .eq('practitioner_id', user.id);
```

### 6.4 Gestion du planning (CRM)

#### Voir son planning hebdomadaire

```js
const { data: schedule } = await supabase
  .from('practitioner_weekly_schedule')
  .select('*')
  .eq('practitioner_id', user.id)
  .order('day_of_week')
  .order('start_time');
```

#### Modifier ses horaires

```js
// Ajouter un creneau
await supabase.from('practitioner_weekly_schedule').insert({
  practitioner_id: user.id,
  day_of_week: 1,         // Lundi
  start_time: '09:00',
  end_time: '12:00',
  slot_duration_minutes: 30,
  is_active: true,
});

// Modifier
await supabase
  .from('practitioner_weekly_schedule')
  .update({ start_time: '08:30', end_time: '12:30' })
  .eq('id', scheduleId);

// Desactiver
await supabase
  .from('practitioner_weekly_schedule')
  .update({ is_active: false })
  .eq('id', scheduleId);
```

#### Gerer les exceptions (vacances, jours speciaux)

```js
// Fermer un jour
await supabase.from('practitioner_schedule_overrides').upsert({
  practitioner_id: user.id,
  date: '2026-03-15',
  is_available: false,
  reason: 'Vacances',
});

// Horaires speciaux
await supabase.from('practitioner_schedule_overrides').upsert({
  practitioner_id: user.id,
  date: '2026-03-20',
  is_available: true,
  start_time: '10:00',
  end_time: '14:00',
  reason: 'Horaires reduits',
});
```

### 6.5 Messagerie CRM

Meme systeme que l'app mobile, mais depuis la perspective du praticien.

#### Lister les conversations

```js
const { data: conversations } = await supabase
  .from('conversations')
  .select(`
    id, last_message_at,
    profiles!patient_id(id, first_name, last_name, avatar_url),
    appointments(id, appointment_date, status)
  `)
  .eq('practitioner_id', user.id)
  .order('last_message_at', { ascending: false, nullsFirst: false });
```

#### Envoyer un message (praticien)

```js
await supabase.from('messages').insert({
  conversation_id: conversationId,
  sender_id: user.id,
  recipient_id: patientId,
  content: text,
  message_type: 'text',
});
```

### 6.6 Vue patient (CRM)

Le praticien peut voir le dossier d'un patient avec qui il a un RDV :

```js
// Profil de base
const { data: patientProfile } = await supabase
  .from('profiles')
  .select('first_name, last_name, email, phone, date_of_birth, sex, city')
  .eq('id', patientId)
  .single();

// Profil sante (RLS autorise car le praticien a un RDV avec ce patient)
const { data: healthProfile } = await supabase
  .from('health_profiles')
  .select('*')
  .eq('user_id', patientId)
  .maybeSingle();

// Conditions medicales
const { data: conditions } = await supabase
  .from('health_conditions')
  .select('name, severity, diagnosed_on, notes')
  .eq('user_id', patientId);

// Allergies
const { data: allergies } = await supabase
  .from('health_allergies')
  .select('name, reaction, severity')
  .eq('user_id', patientId);

// Medicaments
const { data: medications } = await supabase
  .from('health_medications')
  .select('name, dosage, frequency')
  .eq('user_id', patientId);

// Historique des RDV avec ce praticien
const { data: appointmentHistory } = await supabase
  .from('appointments')
  .select('id, appointment_date, start_time, status, practitioner_notes, appointment_reasons(label_fr)')
  .eq('practitioner_id', user.id)
  .eq('patient_id', patientId)
  .order('appointment_date', { ascending: false });
```

### 6.7 Gestion des motifs de consultation (CRM)

```js
// Lister ses motifs
const { data: reasons } = await supabase
  .from('appointment_reasons')
  .select('*')
  .or(`practitioner_id.eq.${user.id},practitioner_id.is.null`)
  .order('sort_order');

// Ajouter un motif
await supabase.from('appointment_reasons').insert({
  practitioner_id: user.id,
  label: 'Consultation initiale',
  label_fr: 'Consultation initiale',
  label_he: 'ביקור ראשון',
  sort_order: 1,
  is_active: true,
});

// Modifier / desactiver
await supabase
  .from('appointment_reasons')
  .update({ is_active: false })
  .eq('id', reasonId);
```

### 6.8 Gestion des instructions (CRM)

```js
// Lister
const { data: instructions } = await supabase
  .from('appointment_instructions')
  .select('*')
  .eq('practitioner_id', user.id)
  .order('sort_order');

// Ajouter
await supabase.from('appointment_instructions').insert({
  practitioner_id: user.id,
  title: 'Documents a apporter',
  content: 'Veuillez apporter votre carte d\'assurance et vos ordonnances.',
  is_active: true,
  sort_order: 0,
});
```

### 6.9 Profil praticien (CRM)

```js
// Mettre a jour son profil praticien
await supabase
  .from('practitioners')
  .update({
    about: newAbout,
    languages: ['Francais', 'Hebreu', 'Anglais'],
    education: 'Faculte de Medecine, Universite de Tel Aviv',
    phone: '+972-...',
    email: 'dr.cohen@clinic.com',
    is_accepting_new_patients: true,
  })
  .eq('id', user.id);
```

---

## 7. Supabase Realtime

### 7.1 Messages en temps reel

Le frontend s'abonne aux nouveaux messages :

```dart
supabase
  .channel('messages')
  .onPostgresChanges(
    event: PostgresChangeEvent.insert,
    schema: 'public',
    table: 'messages',
    filter: PostgresChangeFilter(
      type: PostgresChangeFilterType.eq,
      column: 'recipient_id',
      value: supabase.auth.currentUser!.id,
    ),
    callback: (payload) {
      // Nouveau message recu
      final message = payload.newRecord;
    },
  )
  .subscribe();
```

### 7.2 Mises a jour des rendez-vous

```dart
supabase
  .channel('appointments')
  .onPostgresChanges(
    event: PostgresChangeEvent.update,
    schema: 'public',
    table: 'appointments',
    filter: PostgresChangeFilter(
      type: PostgresChangeFilterType.eq,
      column: 'patient_id',
      value: supabase.auth.currentUser!.id,
    ),
    callback: (payload) {
      // Statut du RDV mis a jour
    },
  )
  .subscribe();
```

### 7.3 Notifications en temps reel

```dart
supabase
  .channel('notifications')
  .onPostgresChanges(
    event: PostgresChangeEvent.insert,
    schema: 'public',
    table: 'notifications',
    filter: PostgresChangeFilter(
      type: PostgresChangeFilterType.eq,
      column: 'user_id',
      value: supabase.auth.currentUser!.id,
    ),
    callback: (payload) {
      // Nouvelle notification
    },
  )
  .subscribe();
```

### 7.4 Presence (statut en ligne)

```dart
final channel = supabase.channel('online-users');
channel
  .onPresenceSync((payload) {
    final state = channel.presenceState();
    // state contient les utilisateurs en ligne
  })
  .subscribe((status, error) async {
    if (status == RealtimeSubscribeStatus.subscribed) {
      await channel.track({
        'user_id': supabase.auth.currentUser!.id,
        'online_at': DateTime.now().toIso8601String(),
      });
    }
  });
```

### 7.5 Configuration requise

Dans le dashboard Supabase :
1. **Database > Replication** : Activer la replication pour les tables `messages`, `appointments`, `notifications`
2. Verifier que le Realtime est active dans les parametres du projet

---

## 8. Supabase Storage

### 8.1 Buckets a creer

| Bucket | Acces | Description |
|--------|-------|-------------|
| `avatars` | Public | Photos de profil (patients + praticiens) |
| `attachments` | Prive | Fichiers joints aux messages |

### 8.2 Policies de storage

#### Bucket `avatars` (public read, auth write)

```sql
-- Lecture publique
create policy "avatars_public_read"
on storage.objects for select
using (bucket_id = 'avatars');

-- Upload/update par le proprietaire
create policy "avatars_auth_write"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'avatars'
  and (storage.foldername(name))[1] = auth.uid()::text
);

create policy "avatars_auth_update"
on storage.objects for update
to authenticated
using (
  bucket_id = 'avatars'
  and (storage.foldername(name))[1] = auth.uid()::text
);
```

#### Bucket `attachments` (prive, acces conversation)

```sql
-- Lecture par participants de la conversation
create policy "attachments_conv_read"
on storage.objects for select
to authenticated
using (
  bucket_id = 'attachments'
  and exists(
    select 1 from conversations c
    where c.id::text = (storage.foldername(name))[1]
      and (c.patient_id = auth.uid() or c.practitioner_id = auth.uid())
  )
);

-- Upload par participants
create policy "attachments_conv_write"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'attachments'
  and exists(
    select 1 from conversations c
    where c.id::text = (storage.foldername(name))[1]
      and (c.patient_id = auth.uid() or c.practitioner_id = auth.uid())
  )
);
```

### 8.3 Upload d'avatar (exemple Flutter)

```dart
final file = File(pickedImagePath);
final filePath = '${supabase.auth.currentUser!.id}/avatar.jpg';

await supabase.storage.from('avatars').upload(filePath, file, fileOptions: FileOptions(upsert: true));

final publicUrl = supabase.storage.from('avatars').getPublicUrl(filePath);

await supabase
  .from('profiles')
  .update({'avatar_url': publicUrl})
  .eq('id', supabase.auth.currentUser!.id);
```

---

## 9. Edge Functions

Les Edge Functions (Deno) sont necessaires pour la logique qui ne peut pas etre faite cote client.

### 9.1 `send-push-notification`

Declenchee par un Database Webhook quand une notification est inseree.

```typescript
// supabase/functions/send-push-notification/index.ts
import { serve } from 'https://deno.land/std/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js';

serve(async (req) => {
  const payload = await req.json();
  const { record } = payload; // notification row

  // Recuperer le device token de l'utilisateur
  // (necessite une table push_tokens)
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  );

  const { data: tokens } = await supabase
    .from('push_tokens')
    .select('token, platform')
    .eq('user_id', record.user_id);

  // Envoyer via FCM / APNs
  for (const { token, platform } of tokens ?? []) {
    // ... logique FCM/APNs
  }

  return new Response(JSON.stringify({ success: true }));
});
```

**Note :** Necessite une table supplementaire `push_tokens` :

```sql
create table if not exists public.push_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  token text not null,
  platform text not null, -- 'ios' | 'android' | 'web'
  created_at timestamptz not null default now(),
  unique(user_id, token)
);
```

### 9.2 `add-payment-method`

Integration Stripe pour tokeniser les cartes :

```typescript
// supabase/functions/add-payment-method/index.ts
serve(async (req) => {
  const { card_token } = await req.json();
  const authHeader = req.headers.get('Authorization')!;

  // Verifier l'utilisateur
  const supabase = createClient(url, anonKey, {
    global: { headers: { Authorization: authHeader } }
  });
  const { data: { user } } = await supabase.auth.getUser();

  // Creer le PaymentMethod dans Stripe
  const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY')!);
  const pm = await stripe.paymentMethods.create({
    type: 'card',
    card: { token: card_token },
  });

  // Sauvegarder dans la base
  await supabase.from('payment_methods').insert({
    user_id: user!.id,
    brand: pm.card!.brand,
    last4: pm.card!.last4,
    expiry_month: pm.card!.exp_month,
    expiry_year: pm.card!.exp_year,
    stripe_payment_method_id: pm.id,
  });

  return new Response(JSON.stringify({ success: true }));
});
```

### 9.3 `send-appointment-reminder`

Cron Edge Function (quotidienne) pour envoyer des rappels :

```typescript
// supabase/functions/send-appointment-reminder/index.ts
// Declenchee par Supabase Cron (pg_cron) chaque jour a 18h

serve(async (req) => {
  const supabase = createClient(url, serviceRoleKey);

  // RDV de demain, status confirmed
  const tomorrow = new Date();
  tomorrow.setDate(tomorrow.getDate() + 1);
  const tomorrowStr = tomorrow.toISOString().split('T')[0];

  const { data: appointments } = await supabase
    .from('appointments')
    .select('id, patient_id, practitioner_id, start_time, practitioners(profiles(first_name, last_name))')
    .eq('appointment_date', tomorrowStr)
    .eq('status', 'confirmed');

  for (const apt of appointments ?? []) {
    await supabase.from('notifications').insert({
      user_id: apt.patient_id,
      type: 'appointment_reminder',
      title: 'Rappel : rendez-vous demain',
      body: `Vous avez un rendez-vous demain a ${apt.start_time.slice(0,5)}.`,
      data: { appointment_id: apt.id },
    });
  }

  return new Response(JSON.stringify({ sent: appointments?.length }));
});
```

---

## 10. Push Notifications

### 10.1 Table `push_tokens` (a ajouter)

```sql
create table if not exists public.push_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  token text not null,
  platform text not null check (platform in ('ios', 'android', 'web')),
  created_at timestamptz not null default now(),
  constraint push_tokens_unique unique (user_id, token)
);

alter table public.push_tokens enable row level security;

create policy "push_tokens_crud_own"
on public.push_tokens for all
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());
```

### 10.2 Enregistrement du token (frontend)

```dart
// Apres obtention du FCM token
await supabase.from('push_tokens').upsert({
  'user_id': supabase.auth.currentUser!.id,
  'token': fcmToken,
  'platform': Platform.isIOS ? 'ios' : 'android',
});
```

### 10.3 Database Webhook

Configurer un Database Webhook dans Supabase :
- **Table** : `notifications`
- **Event** : `INSERT`
- **URL** : `https://<project-ref>.supabase.co/functions/v1/send-push-notification`
- **Headers** : `Authorization: Bearer <SUPABASE_SERVICE_ROLE_KEY>`

---

## 11. Seed Data

Donnees initiales a inserer pour que l'application fonctionne :

### 11.1 Specialites medicales

```sql
insert into public.specialties (name, name_fr, name_he) values
  ('Ophthalmology', 'Ophtalmologie', 'רפואת עיניים'),
  ('Family Medicine', 'Médecine générale', 'רפואת משפחה'),
  ('Cardiology', 'Cardiologie', 'קרדיולוגיה'),
  ('Dermatology', 'Dermatologie', 'דרמטולוגיה'),
  ('Pediatrics', 'Pédiatrie', 'רפואת ילדים'),
  ('Gynecology', 'Gynécologie', 'גינקולוגיה'),
  ('Orthopedics', 'Orthopédie', 'אורתופדיה'),
  ('Neurology', 'Neurologie', 'נוירולוגיה'),
  ('Psychiatry', 'Psychiatrie', 'פסיכיאטריה'),
  ('Internal Medicine', 'Médecine interne', 'רפואה פנימית'),
  ('ENT', 'ORL', 'אף אוזן גרון'),
  ('Urology', 'Urologie', 'אורולוגיה'),
  ('Endocrinology', 'Endocrinologie', 'אנדוקרינולוגיה'),
  ('Gastroenterology', 'Gastro-entérologie', 'גסטרואנטרולוגיה'),
  ('Pulmonology', 'Pneumologie', 'רפואת ריאות')
on conflict do nothing;
```

### 11.2 Motifs de consultation globaux

```sql
insert into public.appointment_reasons (practitioner_id, label, label_fr, sort_order) values
  (null, 'New patient consultation', 'Consultation (nouveau patient)', 0),
  (null, 'Follow-up', 'Suivi / contrôle', 1),
  (null, 'Urgent (pain, discomfort)', 'Urgence (douleur, gêne)', 2),
  (null, 'Prescription renewal', 'Renouvellement ordonnance', 3),
  (null, 'Results / report', 'Résultats / compte-rendu', 4)
on conflict do nothing;
```

### 11.3 Praticiens de test (optionnel, pour le developpement)

Pour creer des praticiens de test :
1. Creer des comptes via Supabase Auth (email/password)
2. Mettre a jour leur role dans `profiles` : `update profiles set role = 'practitioner' where id = '...'`
3. Inserer dans la table `practitioners` avec specialite, adresse, etc.
4. Inserer des horaires dans `practitioner_weekly_schedule`

---

## 12. Securite & Bonnes pratiques

### 12.1 RLS (deja en place)

Toutes les politiques RLS sont definies dans `schema.sql`. Points cles :
- Les patients ne voient que **leurs propres** donnees
- Les praticiens voient **leurs propres** RDV + les donnees sante des patients avec qui ils ont un RDV
- Les admins ont un acces complet
- Les tables publiques (specialties, practitioners actifs, reviews) sont lisibles par tous (y compris `anon`)

### 12.2 Validation cote serveur

Meme avec RLS, ajouter des CHECK constraints dans la DB (deja fait dans schema.sql) :
- `appointments_time_check` : `start_time < end_time`
- `reviews_rating_check` : `rating between 1 and 5`
- `payment_methods_last4_check` : `char_length(last4) = 4`
- `practitioners_sector_check` : valeurs Kupat Holim valides
- etc.

### 12.3 Donnees sensibles

- **Teudat Zehut** (numero d'identite israelien) : stocke chiffre (`bytea` avec `pgcrypto`)
- **Stripe tokens** : ne jamais stocker les numeros de carte complets, uniquement les tokens Stripe
- **Mots de passe** : geres par Supabase Auth (bcrypt)

### 12.4 Rate limiting

Configurer dans les parametres Supabase :
- API rate limits par IP
- Auth rate limits (tentatives de connexion)

### 12.5 Monitoring

Activer :
- Supabase Logs (API, Auth, Database)
- La table `audit_log` pour tracer les actions CRM
- Alertes sur les erreurs critiques

---

## Resume des actions pour le developpeur backend

### Checklist de mise en place

1. [ ] Creer un projet Supabase
2. [ ] Executer `schema.sql` dans le SQL Editor
3. [ ] Executer les seeds (specialites + motifs globaux)
4. [ ] Activer l'authentification email/password
5. [ ] Activer le Realtime sur `messages`, `appointments`, `notifications`
6. [ ] Creer les buckets Storage (`avatars` public, `attachments` prive)
7. [ ] Appliquer les policies de Storage
8. [ ] Creer la table `push_tokens` (section 10.1)
9. [ ] Deployer les Edge Functions :
   - `send-push-notification`
   - `add-payment-method`
   - `send-appointment-reminder`
10. [ ] Configurer le Database Webhook pour les push notifications
11. [ ] Configurer le Cron pour les rappels (pg_cron)
12. [ ] Creer les praticiens de test
13. [ ] Tester chaque endpoint depuis le frontend Flutter
14. [ ] Developper le CRM web (React/Next.js) en utilisant les specifications de la section 6

### Priorites

| Priorite | Fonctionnalite |
|----------|----------------|
| P0 | Auth + Profiles + Schema SQL |
| P0 | Recherche praticiens + Profil praticien |
| P0 | Creneaux disponibles + Booking |
| P0 | Liste des RDV (upcoming/past) + Cancel |
| P1 | Messagerie (conversations + messages + realtime) |
| P1 | CRM: Dashboard + Confirmer/Refuser RDV |
| P1 | CRM: Gestion planning |
| P2 | Profil sante + Listes sante |
| P2 | Notifications (in-app + push) |
| P2 | CRM: Messagerie + Vue patient |
| P3 | Paiements (Stripe) |
| P3 | Avis / Reviews |
| P3 | Storage (avatars, attachments) |
