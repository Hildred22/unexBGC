import argparse
import csv
import os
import shutil


parser = argparse.ArgumentParser()
parser.add_argument("--checkm2", required=True)
parser.add_argument("--bins", required=True)
parser.add_argument("--output", required=True)
args = parser.parse_args()

os.makedirs(args.output, exist_ok=True)

with open(args.checkm2, newline="") as f:
    reader = csv.DictReader(f)

    for row in reader:
        completeness = float(row["Completeness"])
        contamination = float(row["Contamination"])

        hq = completeness >= 90 and contamination <= 5
        mq = completeness >= 50 and contamination <= 10

        if hq or mq:
            sample = row["Sample"]
            name = row["Name"]

            src = os.path.join(
                args.bins,
                sample,
                f"{sample}_DASTool_bins",
                f"{name}.fa"
            )

            dest = os.path.join(
                args.output,
                f"{sample}_{name}.fa"
            )

            if os.path.isfile(src):
                shutil.copy2(src, dest)
