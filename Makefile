REPO_ROOT=.
PART=xc7a35tcpg236-1
IPKERNEL_NAME=snn-practice
IP_NAME=snn-axil
IP_DIR=ip_repo
VSOURCES += $(REPO_ROOT)/common/rtl/snn_axil.sv
CSOURCES += $(REPO_ROOT)/common/contraints/Basys-3-Master.xdc

create_ip: create_snn_axil_project.tcl bd.tcl $(VSOURCES) $(CSOURCES)
	vivado -mode batch -source create_snn_axil_project.tcl -tclargs $(PART) $(IP_NAME) $(IP_DIR)

project: $(IPKERNEL_NAME)-$(PART)/$(IPKERNEL_NAME).xpr
$(IPKERNEL_NAME)-$(PART)/$(IPKERNEL_NAME).xpr: create_bd.tcl bd.tcl $(VSOURCES) $(CSOURCES) $(IP_REPO)
	vivado -mode batch -source create_bd.tcl -tclargs $(PART) $(IPKERNEL_NAME)

run-pnr: run-pnr.tcl $(IPKERNEL_NAME)-$(PART)/$(IPKERNEL_NAME).xpr
	vivado -mode batch -source $< -tclargs $(PART) $(IPKERNEL_NAME)

board-flash: $(IPKERNEL_NAME)-$(PART)/$(IPKERNEL_NAME).runs/impl_1/*.bit board-flash.tcl
	vivado -mode batch -source board-flash.tcl -tclargs $<

page: docs/index.html
docs/index.html: docs/slides.md
	pandoc -t revealjs -s -o $@ $< \
	-V revealjs-url=https://unpkg.com/reveal.js \
	-V theme=black \
    --include-in-header=docs/slides.css \
	--slide-level 3

clean:
	rm -rf $(IPKERNEL_NAME)-$(PART)
	rm -rf $(IP_NAME)-$(PART)
	rm -rf ip_repo
	rm -rf *.jou *.log 
	rm -rf *~
	rm -rf .run
	rm -rf .Xil
	rm -rf docs/index.html

.PHONY: project page snn-axil-project create_ip
