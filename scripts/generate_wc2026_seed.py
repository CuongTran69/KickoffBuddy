#!/usr/bin/env python3
"""
generate_wc2026_seed.py
-----------------------
Parses openfootball/worldcup 2026--usa/cup.txt and cup_finals.txt
and generates a full 104-match JSON seed file.

Usage:
    python3 scripts/generate_wc2026_seed.py

Output:
    assets/data/wc2026_matches.json  (root)
    app/assets/data/wc2026_matches.json  (bundled)

Source data: openfootball/worldcup (CC0)
  https://github.com/openfootball/worldcup/tree/master/2026--usa
"""

import json
import re
from datetime import datetime, timezone, timedelta
from zoneinfo import ZoneInfo
import shutil
import os

# ---------------------------------------------------------------------------
# Venue → IANA timezone mapping (per docs/data/03-team-reference.md)
# ---------------------------------------------------------------------------
VENUE_TIMEZONE = {
    "Mexico City": "America/Mexico_City",
    "Guadalajara (Zapopan)": "America/Mexico_City",
    "Monterrey (Guadalupe)": "America/Monterrey",
    "Atlanta": "America/New_York",
    "Boston (Foxborough)": "America/New_York",
    "Dallas (Arlington)": "America/Chicago",
    "Houston": "America/Chicago",
    "Kansas City": "America/Chicago",
    "Los Angeles (Inglewood)": "America/Los_Angeles",
    "Miami (Miami Gardens)": "America/New_York",
    "New York/New Jersey (East Rutherford)": "America/New_York",
    "Philadelphia": "America/New_York",
    "San Francisco Bay Area (Santa Clara)": "America/Los_Angeles",
    "Seattle": "America/Los_Angeles",
    "Toronto": "America/Toronto",
    "Vancouver": "America/Vancouver",
}

# Friendly display names for venues
VENUE_DISPLAY = {
    "Mexico City": "Mexico City",
    "Guadalajara (Zapopan)": "Guadalajara",
    "Monterrey (Guadalupe)": "Monterrey",
    "Atlanta": "Atlanta",
    "Boston (Foxborough)": "Boston",
    "Dallas (Arlington)": "Dallas",
    "Houston": "Houston",
    "Kansas City": "Kansas City",
    "Los Angeles (Inglewood)": "Los Angeles",
    "Miami (Miami Gardens)": "Miami",
    "New York/New Jersey (East Rutherford)": "East Rutherford, NJ",
    "Philadelphia": "Philadelphia",
    "San Francisco Bay Area (Santa Clara)": "Santa Clara",
    "Seattle": "Seattle",
    "Toronto": "Toronto",
    "Vancouver": "Vancouver",
}

# ---------------------------------------------------------------------------
# UTC offset → IANA (for group stage parsing)
# ---------------------------------------------------------------------------
OFFSET_TO_IANA = {
    "UTC-4": "America/New_York",
    "UTC-5": "America/Chicago",
    "UTC-6": "America/Mexico_City",
    "UTC-7": "America/Los_Angeles",
}

# ---------------------------------------------------------------------------
# Group assignments (from cup.txt header)
# ---------------------------------------------------------------------------
GROUPS = {
    "Mexico": "A", "South Africa": "A", "South Korea": "A", "Czech Republic": "A",
    "Canada": "B", "Bosnia & Herzegovina": "B", "Qatar": "B", "Switzerland": "B",
    "Brazil": "C", "Morocco": "C", "Haiti": "C", "Scotland": "C",
    "USA": "D", "Paraguay": "D", "Australia": "D", "Turkey": "D",
    "Germany": "E", "Curaçao": "E", "Ivory Coast": "E", "Ecuador": "E",
    "Netherlands": "F", "Japan": "F", "Sweden": "F", "Tunisia": "F",
    "Belgium": "G", "Egypt": "G", "Iran": "G", "New Zealand": "G",
    "Spain": "H", "Cape Verde": "H", "Saudi Arabia": "H", "Uruguay": "H",
    "France": "I", "Senegal": "I", "Iraq": "I", "Norway": "I",
    "Argentina": "J", "Algeria": "J", "Austria": "J", "Jordan": "J",
    "Portugal": "K", "DR Congo": "K", "Uzbekistan": "K", "Colombia": "K",
    "England": "L", "Croatia": "L", "Ghana": "L", "Panama": "L",
}

# ---------------------------------------------------------------------------
# Raw openfootball data (fetched from GitHub)
# ---------------------------------------------------------------------------
CUP_TXT = """▪ Group A
Thu June 11
13:00 UTC-6  Mexico v South Africa  @ Mexico City
20:00 UTC-6  South Korea v Czech Republic  @ Guadalajara (Zapopan)
Thu June 18
12:00 UTC-4  Czech Republic v South Africa  @ Atlanta
19:00 UTC-6  Mexico v South Korea  @ Guadalajara (Zapopan)
Wed June 24
19:00 UTC-6  Czech Republic v Mexico  @ Mexico City
19:00 UTC-6  South Africa v South Korea  @ Monterrey (Guadalupe)

▪ Group B
Fri June 12
15:00 UTC-4  Canada v Bosnia & Herzegovina  @ Toronto
Sat June 13
12:00 UTC-7  Qatar v Switzerland  @ San Francisco Bay Area (Santa Clara)
Thu June 18
12:00 UTC-7  Switzerland v Bosnia & Herzegovina  @ Los Angeles (Inglewood)
15:00 UTC-7  Canada v Qatar  @ Vancouver
Wed June 24
12:00 UTC-7  Switzerland v Canada  @ Vancouver
12:00 UTC-7  Bosnia & Herzegovina v Qatar  @ Seattle

▪ Group C
Sat June 13
18:00 UTC-4  Brazil v Morocco  @ New York/New Jersey (East Rutherford)
21:00 UTC-4  Haiti v Scotland  @ Boston (Foxborough)
Fri June 19
18:00 UTC-4  Scotland v Morocco  @ Boston (Foxborough)
20:30 UTC-4  Brazil v Haiti  @ Philadelphia
Wed June 24
18:00 UTC-4  Scotland v Brazil  @ Miami (Miami Gardens)
18:00 UTC-4  Morocco v Haiti  @ Atlanta

▪ Group D
Fri June 12
18:00 UTC-7  USA v Paraguay  @ Los Angeles (Inglewood)
Sat June 13
21:00 UTC-7  Australia v Turkey  @ Vancouver
Fri June 19
12:00 UTC-7  USA v Australia  @ Seattle
20:00 UTC-7  Turkey v Paraguay  @ San Francisco Bay Area (Santa Clara)
Thu June 25
19:00 UTC-7  Turkey v USA  @ Los Angeles (Inglewood)
19:00 UTC-7  Paraguay v Australia  @ San Francisco Bay Area (Santa Clara)

▪ Group E
Sun June 14
12:00 UTC-5  Germany v Curaçao  @ Houston
19:00 UTC-4  Ivory Coast v Ecuador  @ Philadelphia
Sat June 20
16:00 UTC-4  Germany v Ivory Coast  @ Toronto
19:00 UTC-5  Ecuador v Curaçao  @ Kansas City
Thu June 25
16:00 UTC-4  Curaçao v Ivory Coast  @ Philadelphia
16:00 UTC-4  Ecuador v Germany  @ New York/New Jersey (East Rutherford)

▪ Group F
Sun June 14
15:00 UTC-5  Netherlands v Japan  @ Dallas (Arlington)
20:00 UTC-6  Sweden v Tunisia  @ Monterrey (Guadalupe)
Sat June 20
12:00 UTC-5  Netherlands v Sweden  @ Houston
22:00 UTC-6  Tunisia v Japan  @ Monterrey (Guadalupe)
Thu June 25
18:00 UTC-5  Japan v Sweden  @ Dallas (Arlington)
18:00 UTC-5  Tunisia v Netherlands  @ Kansas City

▪ Group G
Mon June 15
12:00 UTC-7  Belgium v Egypt  @ Seattle
18:00 UTC-7  Iran v New Zealand  @ Los Angeles (Inglewood)
Sun June 21
12:00 UTC-7  Belgium v Iran  @ Los Angeles (Inglewood)
18:00 UTC-7  New Zealand v Egypt  @ Vancouver
Fri June 26
20:00 UTC-7  Egypt v Iran  @ Seattle
20:00 UTC-7  New Zealand v Belgium  @ Vancouver

▪ Group H
Mon June 15
12:00 UTC-4  Spain v Cape Verde  @ Atlanta
18:00 UTC-4  Saudi Arabia v Uruguay  @ Miami (Miami Gardens)
Sun June 21
12:00 UTC-4  Spain v Saudi Arabia  @ Atlanta
18:00 UTC-4  Uruguay v Cape Verde  @ Miami (Miami Gardens)
Fri June 26
19:00 UTC-5  Cape Verde v Saudi Arabia  @ Houston
18:00 UTC-6  Uruguay v Spain  @ Guadalajara (Zapopan)

▪ Group I
Tue June 16
15:00 UTC-4  France v Senegal  @ New York/New Jersey (East Rutherford)
18:00 UTC-4  Iraq v Norway  @ Boston (Foxborough)
Mon June 22
17:00 UTC-4  France v Iraq  @ Philadelphia
20:00 UTC-4  Norway v Senegal  @ New York/New Jersey (East Rutherford)
Fri June 26
15:00 UTC-4  Norway v France  @ Boston (Foxborough)
15:00 UTC-4  Senegal v Iraq  @ Toronto

▪ Group J
Tue June 16
20:00 UTC-5  Argentina v Algeria  @ Kansas City
21:00 UTC-7  Austria v Jordan  @ San Francisco Bay Area (Santa Clara)
Mon June 22
12:00 UTC-5  Argentina v Austria  @ Dallas (Arlington)
20:00 UTC-7  Jordan v Algeria  @ San Francisco Bay Area (Santa Clara)
Sat June 27
21:00 UTC-5  Algeria v Austria  @ Kansas City
21:00 UTC-5  Jordan v Argentina  @ Dallas (Arlington)

▪ Group K
Wed June 17
12:00 UTC-5  Portugal v DR Congo  @ Houston
20:00 UTC-6  Uzbekistan v Colombia  @ Mexico City
Tue June 23
12:00 UTC-5  Portugal v Uzbekistan  @ Houston
20:00 UTC-6  Colombia v DR Congo  @ Guadalajara (Zapopan)
Sat June 27
19:30 UTC-4  Colombia v Portugal  @ Miami (Miami Gardens)
19:30 UTC-4  DR Congo v Uzbekistan  @ Atlanta

▪ Group L
Wed June 17
15:00 UTC-5  England v Croatia  @ Dallas (Arlington)
19:00 UTC-4  Ghana v Panama  @ Toronto
Tue June 23
16:00 UTC-4  England v Ghana  @ Boston (Foxborough)
19:00 UTC-4  Panama v Croatia  @ Toronto
Sat June 27
17:00 UTC-4  Panama v England  @ New York/New Jersey (East Rutherford)
17:00 UTC-4  Croatia v Ghana  @ Philadelphia"""

CUP_FINALS_TXT = """▪ Round of 32
Sun Jun 28
(73) 12:00 UTC-7  2A v 2B  @ Los Angeles (Inglewood)
Mon Jun 29
(74) 16:30 UTC-4  1E v 3A/B/C/D/F  @ Boston (Foxborough)
(75) 19:00 UTC-6  1F v 2C  @ Monterrey (Guadalupe)
(76) 12:00 UTC-5  1C v 2F  @ Houston
Tue Jun 30
(77) 17:00 UTC-4  1I v 3C/D/F/G/H  @ New York/New Jersey (East Rutherford)
(78) 12:00 UTC-5  2E v 2I  @ Dallas (Arlington)
(79) 19:00 UTC-6  1A v 3C/E/F/H/I  @ Mexico City
Wed Jul 1
(80) 12:00 UTC-4  1L v 3E/H/I/J/K  @ Atlanta
(81) 17:00 UTC-7  1D v 3B/E/F/I/J  @ San Francisco Bay Area (Santa Clara)
(82) 13:00 UTC-7  1G v 3A/E/H/I/J  @ Seattle
Thu Jul 2
(83) 19:00 UTC-4  2K v 2L  @ Toronto
(84) 12:00 UTC-7  1H v 2J  @ Los Angeles (Inglewood)
(85) 20:00 UTC-7  1B v 3E/F/G/I/J  @ Vancouver
Fri Jul 3
(86) 18:00 UTC-4  1J v 2H  @ Miami (Miami Gardens)
(87) 20:30 UTC-5  1K v 3D/E/I/J/L  @ Kansas City
(88) 13:00 UTC-5  2D v 2G  @ Dallas (Arlington)

▪ Round of 16
Sat Jul 4
(89) 17:00 UTC-4  W74 v W77  @ Philadelphia
(90) 12:00 UTC-5  W73 v W75  @ Houston
Sun Jul 5
(91) 16:00 UTC-4  W76 v W78  @ New York/New Jersey (East Rutherford)
(92) 18:00 UTC-6  W79 v W80  @ Mexico City
Mon Jul 6
(93) 14:00 UTC-5  W83 v W84  @ Dallas (Arlington)
(94) 17:00 UTC-7  W81 v W82  @ Seattle
Tue Jul 7
(95) 12:00 UTC-4  W86 v W88  @ Atlanta
(96) 13:00 UTC-7  W85 v W87  @ Vancouver

▪ Quarter-final
Thu Jul 9
(97) 16:00 UTC-4  W89 v W90  @ Boston (Foxborough)
Fri Jul 10
(98) 12:00 UTC-7  W93 v W94  @ Los Angeles (Inglewood)
Sat Jul 11
(99) 17:00 UTC-4  W91 v W92  @ Miami (Miami Gardens)
(100) 20:00 UTC-5  W95 v W96  @ Kansas City

▪ Semi-final
Tue Jul 14
(101) 14:00 UTC-5  W97 v W98  @ Dallas (Arlington)
Wed Jul 15
(102) 15:00 UTC-4  W99 v W100  @ Atlanta

▪ Match for third place
Sat Jul 18
17:00 UTC-4  L101 v L102  @ Miami (Miami Gardens)

▪ Final
Sun Jul 19
15:00 UTC-4  W101 v W102  @ New York/New Jersey (East Rutherford)"""


def parse_time_to_utc(time_str: str, offset_str: str, date: datetime) -> str:
    """Convert local time + UTC offset to UTC ISO-8601 string."""
    # Parse time
    parts = time_str.split(":")
    hour = int(parts[0])
    minute = int(parts[1]) if len(parts) > 1 else 0

    # Parse offset (e.g., "UTC-6" → -6 hours)
    offset_match = re.match(r"UTC([+-]\d+)", offset_str)
    if not offset_match:
        raise ValueError(f"Cannot parse offset: {offset_str}")
    offset_hours = int(offset_match.group(1))

    # Build local datetime
    local_dt = date.replace(hour=hour, minute=minute, second=0, microsecond=0)

    # Convert to UTC by subtracting the offset
    utc_dt = local_dt - timedelta(hours=offset_hours)
    utc_dt = utc_dt.replace(tzinfo=timezone.utc)

    return utc_dt.strftime("%Y-%m-%dT%H:%M:%SZ")


def parse_date_line(line: str, year: int = 2026):
    """Parse a date line like 'Thu June 11' or 'Sun Jun 28'."""
    # Match patterns like "Thu June 11", "Mon Jun 29", "Sat Jul 4"
    m = re.match(
        r"(?:Mon|Tue|Wed|Thu|Fri|Sat|Sun)\s+(Jan|Feb|Mar|Apr|May|Jun|June|Jul|Aug|Sep|Oct|Nov|Dec)\s+(\d+)",
        line.strip(),
    )
    if not m:
        return None
    month_str = m.group(1)
    day = int(m.group(2))
    month_map = {
        "Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5,
        "Jun": 6, "June": 6, "Jul": 7, "Aug": 8,
        "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12,
    }
    month = month_map[month_str]
    return datetime(year, month, day)


def parse_group_stage(text: str) -> list[dict]:
    """Parse group stage matches from cup.txt content."""
    matches = []
    current_group = None
    current_date = None
    match_counter = 1

    # Track matchday per group
    group_matchday = {g: 0 for g in "ABCDEFGHIJKL"}
    group_match_count = {g: 0 for g in "ABCDEFGHIJKL"}

    lines = text.strip().split("\n")

    for line in lines:
        line = line.strip()
        if not line:
            continue

        # Group header: "▪ Group A"
        group_m = re.match(r"▪ Group ([A-L])", line)
        if group_m:
            current_group = group_m.group(1)
            continue

        # Date line
        date_parsed = parse_date_line(line)
        if date_parsed:
            current_date = date_parsed
            continue

        # Match line: "13:00 UTC-6  Mexico v South Africa  @ Mexico City"
        match_m = re.match(
            r"(\d{1,2}:\d{2})\s+(UTC[+-]\d+)\s+(.+?)\s+v\s+(.+?)\s+@\s+(.+)$",
            line,
        )
        if match_m and current_group and current_date:
            time_str = match_m.group(1)
            offset_str = match_m.group(2)
            team_a = match_m.group(3).strip()
            team_b = match_m.group(4).strip()
            venue_raw = match_m.group(5).strip()

            # Determine matchday: every 2 matches in a group = 1 matchday
            group_match_count[current_group] += 1
            count = group_match_count[current_group]
            if count <= 2:
                matchday = 1
            elif count <= 4:
                matchday = 2
            else:
                matchday = 3

            kickoff_utc = parse_time_to_utc(time_str, offset_str, current_date)
            venue_iana = VENUE_TIMEZONE.get(venue_raw, "America/New_York")
            venue_city = VENUE_DISPLAY.get(venue_raw, venue_raw)
            source_tz = OFFSET_TO_IANA.get(offset_str, "America/New_York")

            match_id = f"match_{match_counter:03d}"
            match_counter += 1

            matches.append({
                "id": match_id,
                "title": f"{team_a} vs {team_b}",
                "teamA": team_a,
                "teamB": team_b,
                "kickoffAtUtc": kickoff_utc,
                "sourceTimezone": source_tz,
                "userTimezone": "UTC",
                "reminders": [1440, 180, 30, 5],
                "replayPlannerEnabled": False,
                "replayPlannedAt": None,
                "sourceText": None,
                "notes": "",
                "createdAt": "2026-05-28T00:00:00Z",
                "isSeeded": True,
                "tournamentId": "wc2026",
                "worldCupGroup": current_group,
                "worldCupRound": "group_stage",
                "matchday": matchday,
                "venueCity": venue_city,
                "venueIanaTimezone": venue_iana,
            })

    return matches


def parse_knockout_stage(text: str, start_counter: int) -> list[dict]:
    """Parse knockout stage matches from cup_finals.txt content."""
    matches = []
    current_round = None
    current_date = None
    match_counter = start_counter

    # Round name mapping
    round_map = {
        "Round of 32": "round_of_32",
        "Round of 16": "round_of_16",
        "Quarter-final": "quarter_final",
        "Semi-final": "semi_final",
        "Match for third place": "third_place",
        "Final": "final",
    }

    lines = text.strip().split("\n")

    for line in lines:
        line = line.strip()
        if not line:
            continue

        # Round header: "▪ Round of 32"
        round_m = re.match(r"▪ (.+)$", line)
        if round_m:
            round_name = round_m.group(1).strip()
            current_round = round_map.get(round_name)
            continue

        # Date line
        date_parsed = parse_date_line(line)
        if date_parsed:
            current_date = date_parsed
            continue

        # Match line with match number: "(73) 12:00 UTC-7  2A v 2B  @ Los Angeles (Inglewood)"
        # Or without number: "17:00 UTC-4  L101 v L102  @ Miami (Miami Gardens)"
        match_m = re.match(
            r"(?:\(\d+\)\s+)?(\d{1,2}:\d{2})\s+(UTC[+-]\d+)\s+(.+?)\s+v\s+(.+?)\s+@\s+(.+)$",
            line,
        )
        if match_m and current_round and current_date:
            time_str = match_m.group(1)
            offset_str = match_m.group(2)
            team_a = match_m.group(3).strip()
            team_b = match_m.group(4).strip()
            venue_raw = match_m.group(5).strip()

            kickoff_utc = parse_time_to_utc(time_str, offset_str, current_date)
            venue_iana = VENUE_TIMEZONE.get(venue_raw, "America/New_York")
            venue_city = VENUE_DISPLAY.get(venue_raw, venue_raw)
            source_tz = OFFSET_TO_IANA.get(offset_str, "America/New_York")

            match_id = f"match_{match_counter:03d}"
            match_counter += 1

            matches.append({
                "id": match_id,
                "title": f"{team_a} vs {team_b}",
                "teamA": team_a,
                "teamB": team_b,
                "kickoffAtUtc": kickoff_utc,
                "sourceTimezone": source_tz,
                "userTimezone": "UTC",
                "reminders": [1440, 180, 30, 5],
                "replayPlannerEnabled": False,
                "replayPlannedAt": None,
                "sourceText": None,
                "notes": "",
                "createdAt": "2026-05-28T00:00:00Z",
                "isSeeded": True,
                "tournamentId": "wc2026",
                "worldCupGroup": None,
                "worldCupRound": current_round,
                "matchday": None,
                "venueCity": venue_city,
                "venueIanaTimezone": venue_iana,
            })

    return matches


def validate_matches(matches: list[dict]) -> None:
    """Validate the generated matches."""
    assert len(matches) == 104, f"Expected 104 matches, got {len(matches)}"

    group_stage = [m for m in matches if m["worldCupRound"] == "group_stage"]
    knockouts = [m for m in matches if m["worldCupRound"] != "group_stage"]
    assert len(group_stage) == 72, f"Expected 72 group stage matches, got {len(group_stage)}"
    assert len(knockouts) == 32, f"Expected 32 knockout matches, got {len(knockouts)}"

    # Validate all IANA timezones
    all_iana = set()
    for m in matches:
        all_iana.add(m["venueIanaTimezone"])
        all_iana.add(m["sourceTimezone"])

    for tz_name in all_iana:
        try:
            ZoneInfo(tz_name)
        except Exception as e:
            raise ValueError(f"Invalid IANA timezone: {tz_name}: {e}")

    # Validate required fields
    required_fields = [
        "id", "title", "teamA", "teamB", "kickoffAtUtc", "sourceTimezone",
        "userTimezone", "reminders", "replayPlannerEnabled", "replayPlannedAt",
        "sourceText", "notes", "createdAt", "isSeeded", "tournamentId",
        "worldCupRound", "venueCity", "venueIanaTimezone",
    ]
    for m in matches:
        for field in required_fields:
            assert field in m, f"Match {m.get('id')} missing field: {field}"

    # Validate group stage has worldCupGroup and matchday
    for m in group_stage:
        assert m["worldCupGroup"] is not None, f"Group stage match {m['id']} missing worldCupGroup"
        assert m["matchday"] is not None, f"Group stage match {m['id']} missing matchday"

    print(f"Validation passed: {len(matches)} matches ({len(group_stage)} group stage + {len(knockouts)} knockouts)")
    print(f"IANA timezones used: {sorted(all_iana)}")


def main():
    print("Parsing group stage matches...")
    group_matches = parse_group_stage(CUP_TXT)
    print(f"  Parsed {len(group_matches)} group stage matches")

    print("Parsing knockout stage matches...")
    knockout_matches = parse_knockout_stage(CUP_FINALS_TXT, start_counter=len(group_matches) + 1)
    print(f"  Parsed {len(knockout_matches)} knockout matches")

    all_matches = group_matches + knockout_matches

    print("Validating...")
    validate_matches(all_matches)

    output = {
        "tournament": "FIFA World Cup 2026",
        "version": "1.0.0",
        "lastUpdated": "2026-05-28",
        "source": "openfootball/worldcup (CC0) — https://github.com/openfootball/worldcup/tree/master/2026--usa",
        "matches": all_matches,
    }

    # Write to root assets
    root_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), "assets", "data", "wc2026_matches.json")
    os.makedirs(os.path.dirname(root_path), exist_ok=True)
    with open(root_path, "w", encoding="utf-8") as f:
        json.dump(output, f, ensure_ascii=False, indent=2)
    print(f"Written: {root_path}")

    # Copy to app/assets
    app_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), "app", "assets", "data", "wc2026_matches.json")
    os.makedirs(os.path.dirname(app_path), exist_ok=True)
    shutil.copy2(root_path, app_path)
    print(f"Copied:  {app_path}")

    print("Done!")


if __name__ == "__main__":
    main()
