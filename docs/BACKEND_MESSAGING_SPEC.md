# Spécifications Backend - Messagerie

Ce document décrit ce que le frontend attend du backend pour le système de messagerie, et les écarts éventuels avec l'OpenAPI actuel.

## Endpoints utilisés (OK)

| Endpoint | Usage |
|----------|-------|
| `GET /api/v1/conversations` | Liste des conversations |
| `GET /api/v1/conversations/{id}/messages` | Messages d'une conversation |
| `POST /api/v1/conversations/{id}/messages` | Envoyer un message |
| `PATCH /api/v1/conversations/{id}/read` | Marquer comme lu |

## Structure attendue pour GET /conversations

Le frontend parse chaque élément du tableau comme suit :

```json
{
  "id": "uuid",
  "practitioners": {
    "profiles": {
      "first_name": "Marc",
      "last_name": "BENHAMOU"
    }
  },
  "last_message": {
    "content": "Dernier message..."
  },
  "last_message_at": "2025-02-22T14:00:00Z",
  "unread_count": 2,
  "appointments": {
    "id": "uuid",
    "status": "confirmed",
    "appointment_date": "2025-02-19"
  }
}
```

**Note :** Si `practitioners` est un tableau (plusieurs praticiens), le frontend doit être adapté. Actuellement il attend un objet unique avec `profiles`.

## Structure attendue pour les messages

Conforme au schéma `Message` de l'OpenAPI : `id`, `sender_id`, `content`, `message_type`, `is_read`, `created_at`.

## Endpoints manquants / à ajouter

### 1. `GET /api/v1/conversations/{id}` (recommandé)

**Usage :** Récupérer les détails d'une conversation (nom du praticien/cabinet, statut en ligne, etc.) quand on navigue vers la page conversation sans avoir la liste en cache (ex. deep link, notification).

**Réponse attendue :**
```json
{
  "id": "uuid",
  "name": "Cabinet Dr BENHAMOU",
  "practitioners": { ... },
  "is_online": false
}
```

### 2. `POST /api/v1/conversations` (pour nouveau message)

**Usage :** Créer une nouvelle conversation (page "Nouveau message"). Actuellement le frontend redirige vers la liste avec "Bientôt disponible".

**Request :**
```json
{
  "practitioner_id": "uuid",
  "subject": "Sujet",
  "content": "Premier message"
}
```

**Réponse :** L'objet conversation créé avec son `id`, ou le `Message` créé.

### 3. `conversation_id` dans les rendez-vous

**Usage :** Sur la page détail d'un RDV, le bouton "Contacter le cabinet" pourrait naviguer directement vers la conversation liée au RDV.

**À ajouter dans :** `GET /api/v1/appointments/{id}` → inclure `conversation_id` si une conversation existe pour ce RDV.

## Résumé des modifications frontend effectuées

- Suppression des données démo (Cabinet Dr BENHAMOU hardcodé)
- Affichage des vraies données de conversation (nom, avatar) passées via la navigation
- Shimmer de chargement sur la page conversation et la liste des messages
- Navigation depuis la liste messages et la home : passage de l'objet `ConversationPreview` en `extra`
- Page détail RDV : redirection vers `/messages` (liste) en attendant `conversation_id` dans l'API
- Page nouveau message : redirection vers `/messages` avec SnackBar "Bientôt disponible" en attendant `POST /conversations`
