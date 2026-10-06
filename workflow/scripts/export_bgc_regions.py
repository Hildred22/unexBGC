import csv
import json
import re
from pathlib import Path


def parse_json(path):

    result_list = []

    with path.open() as f:
        data = json.load(f)

    for record in data["records"]:

        if not record["areas"]:
            continue

        regions = [
            feature
            for feature in record["features"]
            if feature["type"] == "region"
        ]

        # Add KnownClusterBlast results if present
        try:
            knownblast = record["modules"][
                "antismash.modules.clusterblast"
            ]["knowncluster"]["results"]

        except (KeyError, TypeError, AttributeError):
            knownblast = None

        for i, region in enumerate(regions):

            start, end = re.findall(
                r"\d+",
                region["location"]
            )

            region_dict = {
                "file": path.stem,
                "record_id": record["name"],
                "region": region["qualifiers"]["region_number"][0],
                "start": start,
                "end": end,
                "contig_edge": region["qualifiers"]["contig_edge"][0],
                "product": " / ".join(
                    region["qualifiers"]["product"]
                ),
                "record_desc": record["description"],
            }

            kcb_dict = {
                "KCB_hit": "",
                "KCB_acc": "",
                "KCB_sim": ""
            }

            if knownblast:

                hits = knownblast[i]["ranking"]

                if hits:

                    sim = hits[0][1]["similarity"]

                    if sim > 15:

                        if sim > 75:
                            sim = "high"

                        elif sim > 50:
                            sim = "medium"

                        else:
                            sim = "low"

                        kcb_dict = {
                            "KCB_hit": hits[0][0]["description"],
                            "KCB_acc": hits[0][0]["accession"],
                            "KCB_sim": sim,
                        }

            region_dict.update(kcb_dict)

            result_list.append(region_dict)

    return result_list


def main():

    import argparse

    parser = argparse.ArgumentParser(
        description="Extract BGC region information from antiSMASH JSON files."
    )

    parser.add_argument(
        "--input",
        required=True,
        help="Directory containing antiSMASH sample output directories."
    )

    parser.add_argument(
        "--output",
        required=True,
        help="Output BGC region TSV file."
    )

    args = parser.parse_args()

    asdir = Path(args.input)
    outpath = Path(args.output)

    jsons = sorted(asdir.glob("*/*.json"))

    print(
        f"Found {len(jsons)} JSON files.",
        flush=True
    )

    record_infos = []

    for number, path in enumerate(jsons, start=1):

        print(
            f"[{number}/{len(jsons)}] Processing: {path}",
            flush=True
        )

        record_infos.extend(
            parse_json(path)
        )

    fieldnames = [
        "file",
        "record_id",
        "region",
        "start",
        "end",
        "contig_edge",
        "product",
        "KCB_hit",
        "KCB_acc",
        "KCB_sim",
        "record_desc",
    ]

    outpath.parent.mkdir(
        parents=True,
        exist_ok=True
    )

    with outpath.open("w", newline="") as outf:

        writer = csv.DictWriter(
            outf,
            fieldnames=fieldnames,
            delimiter="\t"
        )

        writer.writeheader()
        writer.writerows(record_infos)

    print(
        f"Finished successfully.",
        flush=True
    )

    print(
        f"Total BGC regions: {len(record_infos)}",
        flush=True
    )

    print(
        f"Output file: {outpath}",
        flush=True
    )


if __name__ == "__main__":
    main()
