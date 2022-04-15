
from gem5.utils.requires import requires
from gem5.components.boards.x86_board import X86Board
from gem5.components.memory.single_channel import SingleChannelDDR3_1600
from gem5.components.cachehierarchies.\
     ruby.mesi_two_level_cache_hierarchy import (MESITwoLevelCacheHierarchy,)
from gem5.components.processors.simple_switchable_processor \
                           import SimpleSwitchableProcessor
from gem5.coherence_protocol import CoherenceProtocol
from gem5.isas import ISA
from gem5.components.processors.cpu_types import CPUTypes
from gem5.resources.resource \
     import Resource, CustomResource, CustomDiskImageResource
from gem5.simulate.simulator import Simulator
from gem5.simulate.exit_event import ExitEvent

import argparse



# This runs a check to ensure the gem5 binary is compiled to X86 and supports
# the MESI Two Level coherence protocol.
requires(
    isa_required=ISA.X86,
    coherence_protocol_required=CoherenceProtocol.MESI_TWO_LEVEL,
    kvm_required=True,
)


def run(args):
# Here we setup a MESI Two Level Cache Hierarchy.

  print("l2size:",type(args.l2_size))


  cache_hierarchy = MESITwoLevelCacheHierarchy(
    l1d_size=args.l1d_size,
    l1d_assoc=8,
    l1i_size=args.l1i_size,
    l1i_assoc=8,
    l2_size=args.l2_size,
    l2_assoc=16,
    num_l2_banks=1,
  )

# Setup the system memory.
# Note, by default DDR3_1600 defaults to a size of 8GiB. However, a current
# limitation with the X86 board is it can only accept memory systems up to 3GB.
# As such, we must fix the size.
  memory = SingleChannelDDR3_1600("2GiB")

# Here we setup the processor. This is a special switchable processor in which
# a starting core type and a switch core type must be specified. Once a
# configuration is instantiated a user may call `processor.switch()` to switch
# from the starting core types to the switch core types. In this simulation
# we start with KVM cores to simulate the OS boot, then switch to the Timing
# cores for the command we wish to run after boot.
  processor = SimpleSwitchableProcessor(
    starting_core_type=CPUTypes.KVM,
    switch_core_type=CPUTypes.O3,
    num_cores=args.num_cores,
  )

# Here we setup the board. The X86Board allows for Full-System X86 simulations.
  board = X86Board(
    clk_freq="3GHz",
    processor=processor,
    memory=memory,
    cache_hierarchy=cache_hierarchy,
  )

# This is the command to run after the system has booted. The first `m5 exit`
# will stop the simulation so we can switch the CPU cores from KVM to timing
# and continue the simulation to run the echo command, sleep for a second,
# then, again, call `m5 exit` to terminate the simulation. After simulation
# has ended you may inspect `m5out/system.pc.com_1.device` to see the echo
# output.
#command = "m5 exit;" \
#        + "echo 'This is running on Timing CPU cores.';" \
#        + "sleep 1;" \
#        + "m5 exit;"

#command = ""

  command = "m5 exit;" \
        + "echo 'This is running on O3 CPU cores.';" \
        + "sleep 1;" \
        + "cd /home/gem5/sysbench-tpcc && source ../run_tpcc.sh;" \
        + "m5 exit;"

# source /home/gem5/run_sysbench.sh;" \

# Here we set the Full System workload.
# The `set_workload` function for the X86Board takes a kernel, a disk image,
# and, optionally, a the contents of the "readfile". In the case of the
# "x86-ubuntu-18.04-img", a file to be executed as a script after booting the
# system.
  board.set_kernel_disk_workload(
    kernel=Resource("x86-linux-kernel-5.4.49",),
    disk_image=CustomDiskImageResource(
      "/home/common/x86-ubuntu-18.04-img", disk_root_partition="1"),
    readfile_contents=command,
)

  simulator = Simulator(
    board=board,
    on_exit_event={
        # Here we want override the default behavior for the first m5 exit
        # exit event. Instead of exiting the simulator, we just want to
        # switch the processor. The 2nd 'm5 exit' after will revert to using
        # default behavior where the simulator run will exit.
        ExitEvent.EXIT : (func() for func in [processor.switch]),
    },
  )
  simulator.run()




parser = argparse.ArgumentParser(
        description="Parameters to sweep for database workloads"
)
    # cpu parameters
parser.add_argument("--l1d_size", type=str, default="32KiB")
parser.add_argument("--l1i_size", type=str, default="32KiB")
parser.add_argument("--l2_size", type=str, default="256KB")
parser.add_argument("--num_cores", type=int, default=2)

args = parser.parse_args()

print("Starting the run")
print("l2 size:",args.l2_size)
run(args)

