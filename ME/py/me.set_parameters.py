"""Set default values of user-adjustable parameters."""

cnsts = {
    "cnst2": 127,
    "cnst3": 117,
    "cnst8": 2.5,
    "cnst9": 0.9,
    "cnst10": 0.10125,
    "cnst11": 0.25125,
    "cnst20": 93,
    "cnst21": 55,
    "cnst22": 176.5,
    "cnst24": 40,
    "cnst25": 44,
    "cnst26": 35,
    "cnst27": 45,
    "cnst28": 125,
    "cnst29": 127,
    "cnst41": 8.5,
    "cnst42": 3.5,
    "cnst43": 3,
    "cnst44": 7,
    "cnst51": 7,
    "cnst61": 0.5,
}

delays = {
    "d1": 1.2,
    "d3": 0.002,
    "d9": 0.02,
    "d11": 0.03,
    "d13": 0.000004,
    "d21": 0.0054,
    "d22": 0.0054,
    "d23": 0.0054,
    "d24": 0.0035,
    "d25": 0.0026,
    "d26": 0.0018,
    "d27": 0.0014,
    "d28": 0.0032,
    "d29": 0.0032,
    "d30": 0.028,
    "d31": 0.028,
    "d32": 0.0091,
    "d33": 0.0063,
    "d34": 0.0091,
    "d35": 0.0286,
    "d36": 0.0286,
    "d37": 0.0071,
    "d38": 0.028,
    "d39": 0.028,
    "d40": 0.05,
    "d41": 0.004,
    "d42": 0.0035,
    "d46": 0.000,
    "d50": 0.02,
    "d51": 0.02,
    "d56": 0.000,
}

pulses = {"p17": "2.5m"}

for key, value in cnsts.items():
    PUTPAR(key, str(value))

for key, value in delays.items():
    PUTPAR(key, str(value))

for key, value in pulses.items():
    PUTPAR(key, str(value))
