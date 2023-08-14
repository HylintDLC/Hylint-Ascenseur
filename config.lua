-----------------Pour obtenir de l'aide, des scripts, etc.----------------
--------------- https://discord.gg/c9ZMqvMUEE  ---------------------------
--------------------------------------------------------------------------

Config = {}

Config.Elevators = {
    PillboxHopital = { -- Nom de l'ascenseur (n'est pas  montré c'est juste pour nommer la table)
        [1] = {
            coords = vec3(332.37, -595.56, 43.28), -- Coordonnées
            heading = 70.65, -- Heading de rotation
            title = 'Étage 2', -- Titre
            description = 'Étage Principale', -- Description
            target = { -- Longueur/largeur cible
                width = 5,
                length = 4
            },
            groups = {-- Exemple whitelist
                'police',
                'ambulance'
            },
        },
        [2] = {
            coords = vec3(344.31, -586.12, 28.79), -- Coordonnées
            heading = 252.84,
            title = 'Étage 1',
            description = 'Sous Sol',
            target = {
            width = 5,
            length = 4
            } -- Exemple sans whitelist
        },
    },
}
