# Spécification backend – Proches (relatives)

Ce document décrit ce que le backend doit implémenter pour supporter l’ajout de proches avec toutes les informations requises.

## État actuel vs. requis

### Table `relatives` (ARCHITECTURE_DB.md)

**Actuellement :**
- `id`, `user_id`, `first_name`, `last_name`, `relation`, `date_of_birth`, `created_at`

**À ajouter :**
- `teudat_zehut` (ou `teudat_zehut_encrypted` / `teudat_zehut_hash` selon la politique de sécurité) – **obligatoire**
- `kupat_holim` (text, nullable) – optionnel
- `insurance_provider` (text, nullable) – optionnel
- `avatar_url` (text, nullable) – optionnel, URL de l’avatar du proche

### API OpenAPI (openapi.yaml)

**Schéma `AddRelativeRequest` – à compléter :**

```yaml
AddRelativeRequest:
  type: object
  properties:
    first_name: { type: string, minLength: 1 }
    last_name: { type: string, minLength: 1 }
    teudat_zehut: { type: string, minLength: 9, maxLength: 9 }  # NOUVEAU – obligatoire
    date_of_birth: { type: string, format: date, nullable: true }
    relation: { $ref: "#/components/schemas/RelationType" }
    kupat_holim: { type: string, nullable: true }   # NOUVEAU – optionnel
    insurance_provider: { type: string, nullable: true }  # NOUVEAU – optionnel
  required: [first_name, last_name, teudat_zehut, relation]
```

**Schéma `Relative` (réponse) – à compléter :**

```yaml
Relative:
  type: object
  properties:
    id: { type: string, format: uuid }
    first_name: { type: string }
    last_name: { type: string }
    teudat_zehut: { type: string, nullable: true }   # NOUVEAU – si stocké
    relation: { $ref: "#/components/schemas/RelationType" }
    date_of_birth: { type: string, format: date, nullable: true }
    kupat_holim: { type: string, nullable: true }    # NOUVEAU
    insurance_provider: { type: string, nullable: true }  # NOUVEAU
  required: [id, first_name, last_name, relation]
```

## Données envoyées par le frontend (POST /api/v1/relatives)

| Champ              | Type   | Obligatoire | Description                                      |
|--------------------|--------|-------------|--------------------------------------------------|
| `first_name`       | string | Oui         | Prénom                                           |
| `last_name`        | string | Oui         | Nom de famille                                   |
| `teudat_zehut`     | string | Oui         | Numéro d’identité israélien (9 chiffres)         |
| `date_of_birth`    | string | Oui         | Date au format ISO 8601 (YYYY-MM-DD)             |
| `relation`         | string | Oui         | `child`, `parent`, `spouse`, `sibling`, `other`  |
| `kupat_holim`      | string | Non         | `clalit`, `maccabi`, `meuhedet`, `leumit`, `other` ou vide |
| `insurance_provider` | string | Non       | Assurance complémentaire (texte libre)            |
| `avatar_url`         | string | Non       | URL de l’avatar (ex. Supabase Storage)             |

## Migration SQL suggérée

```sql
-- Ajout des colonnes manquantes à la table relatives
ALTER TABLE public.relatives
  ADD COLUMN IF NOT EXISTS teudat_zehut_encrypted bytea,
  ADD COLUMN IF NOT EXISTS teudat_zehut_hash text,
  ADD COLUMN IF NOT EXISTS kupat_holim text,
  ADD COLUMN IF NOT EXISTS insurance_provider text,
  ADD COLUMN IF NOT EXISTS avatar_url text;

-- Si teudat_zehut en clair (à éviter en prod) :
-- ALTER TABLE public.relatives ADD COLUMN teudat_zehut text;
```

**Note :** Le frontend envoie `teudat_zehut` en clair. Le backend doit le chiffrer ou le hacher avant stockage selon la politique de sécurité.

## PATCH /api/v1/relatives/{id}

Pour permettre la modification d’un proche, le backend doit implémenter :

- **Méthode** : PATCH
- **Body** : identique à `AddRelativeRequest` (first_name, last_name, teudat_zehut, date_of_birth, relation, kupat_holim, insurance_provider, avatar_url)
- **Réponse** : 200 avec l’objet `Relative` mis à jour

## POST /api/v1/relatives/{id}/avatar

Pour permettre l’upload d’un avatar pour un proche existant :

- **Méthode** : POST
- **Content-Type** : multipart/form-data
- **Body** : champ `avatar` (fichier image)
- **Réponse** : 200 avec `{ "avatar_url": "https://..." }`
- Le backend met à jour la colonne `avatar_url` du proche correspondant.

## Erreur "Unauthorized"

L’erreur "Unauthorized" affichée sur la page "Mes proches" indique que l’API `/api/v1/relatives` (GET ou POST) renvoie 401. Vérifier que :

1. Le token JWT Supabase est bien envoyé dans le header `Authorization: Bearer <token>`
2. Les politiques RLS Supabase (si utilisées) autorisent l’accès aux `relatives` pour l’utilisateur connecté
3. Le backend valide correctement le JWT et associe les proches au `user_id` de l’utilisateur authentifié
