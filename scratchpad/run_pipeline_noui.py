# Giữ cho lệnh cũ: python scratchpad/run_pipeline_noui.py  ->  tools/pipeline.py --no-ui
import os, runpy, sys
sys.argv = [sys.argv[0], "--no-ui"] + sys.argv[1:]
runpy.run_path(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "tools", "pipeline.py"), run_name="__main__")
