# SCL C1D alternate-row legalization rule
# Historical SCL reference flow keeps every other placement row.

source $::env(SCRIPTS_DIR)/openroad/common/io.tcl
read

set block [ord::get_db_block]
set rows [$block getRows]

puts "\[INFO\] SCL rows before deletion: [llength $rows]"

set count 0
set removed 0

foreach row $rows {
    if { [expr {$count % 2}] != 0 } {
        odb::dbRow_destroy $row
        incr removed
    }
    incr count
}

set remaining [llength [$block getRows]]

puts "\[INFO\] SCL rows removed: $removed"
puts "\[INFO\] SCL rows remaining: $remaining"

write
