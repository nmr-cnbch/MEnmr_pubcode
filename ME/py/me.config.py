from java.awt.event import ActionListener

from java.awt import Component

from javax.swing import (
    BoxLayout,
    GroupLayout,
    JButton,
    JCheckBox,
    JComboBox,
    JFrame,
    JLabel,
    JPanel,
    JTextField,
    WindowConstants,
)

# Alignments:
baseline = GroupLayout.Alignment.BASELINE
leading = GroupLayout.Alignment.LEADING
center = GroupLayout.Alignment.CENTER
trailing = GroupLayout.Alignment.TRAILING

def split_options(zgoptns):
    """Split ZGOPTNS into a list."""
    zgoptns = zgoptns.split()
    options = set()
    for opt in zgoptns:
        options.add(opt[2:])
    return options


def join_options(options):
    """Join options into a ZGOPTNS string."""
    zgoptns = ""
    for opt in options:
        zgoptns += " -D" + opt
    return zgoptns


def add_option(options, option):
    """Add an option to the list."""
    if option not in options:
        options.add(option)
    return options


def remove_option(options, option):
    """Remove an option from the list."""
    if option in options:
        options.remove(option)
    return options


def action_add_option(option):
    """add_option packaged for use in action listeners."""
    ct = EXEC_PYSCRIPT(
        'root.GlobalSettings.globalProp.setProperty("MY_ZGOPTNS", GETPAR("ZGOPTNS"))'
    )
    ct.join()
    zgoptns = root.GlobalSettings.globalProp.getProperty("MY_ZGOPTNS")
    options = split_options(zgoptns)
    options = add_option(options, option)
    zgoptns = join_options(options)
    root.GlobalSettings.globalProp.setProperty("MY_ZGOPTNS", zgoptns)
    ct = EXEC_PYSCRIPT(
        'PUTPAR("ZGOPTNS", root.GlobalSettings.globalProp.getProperty("MY_ZGOPTNS"))'
    )
    ct.join()


def action_remove_option(option):
    """remove_option packaged for use in action listeners."""
    ct = EXEC_PYSCRIPT(
        'root.GlobalSettings.globalProp.setProperty("MY_ZGOPTNS", GETPAR("ZGOPTNS"))'
    )
    ct.join()
    zgoptns = root.GlobalSettings.globalProp.getProperty("MY_ZGOPTNS")
    options = split_options(zgoptns)
    options = remove_option(options, option)
    zgoptns = join_options(options)
    root.GlobalSettings.globalProp.setProperty("MY_ZGOPTNS", zgoptns)
    ct = EXEC_PYSCRIPT(
        'PUTPAR("ZGOPTNS", root.GlobalSettings.globalProp.getProperty("MY_ZGOPTNS"))'
    )
    ct.join()

# Put defaults in ZGOPTNS:
PUTPAR("ZGOPTNS", "-DPROXIMAL_HSQC_SE -DDISTAL_HMQC")

# Read ZGOPTNS
zgoptns = GETPAR("ZGOPTNS")
options = split_options(zgoptns)

# Determine starting options:
options = split_options(GETPAR("ZGOPTNS"))

# Map option to ZGOPTNS:
proximal_map = {"HSQC": "HSQC", "HMQC": "HMQC", "Sensitivity enhanced HSQC": "PROXIMAL_HSQC_SE"}
distal_map = {"HSQC": "DISTAL_HSQC", "HMQC": "DISTAL_HMQC"}

# Store state of combo boxes:
proximal_nucleus = "N"
distal_nucleus = "N"
proximal_type = "Sensitivity enhanced HSQC"
distal_type = "HMQC"

# Proximal panel:
def create_proximal():
    """Create a panel for the proximal dimension."""

    def proximal_options(event):
        if GS_box.isSelected():
            action_add_option("GS")
        else:
            action_remove_option("GS")
        if GRAD_box.isSelected():
            action_add_option("GRAD")
        else:
            action_remove_option("GRAD")
        if GRAD_SHORT_box.isSelected():
            action_add_option("GRAD_SHORT")
        else:
            action_remove_option("GRAD_SHORT")

    class ProximalTypeListner(ActionListener):
        def actionPerformed(self, event):
            global proximal_type
            new_proximal_type = proximal_type_box.getSelectedItem()
            if new_proximal_type != proximal_type:
                action_remove_option(proximal_map[proximal_type])
                action_add_option(proximal_map[new_proximal_type])
                proximal_type = new_proximal_type

    if "GS" in options:
        GS = True
    else:
        GS = False
    if "GRAD" in options:
        GRAD = True
    else:
        GRAD = False
    if "GRAD_SHORT" in options:
        GRAD_SHORT = True
    else:
        GRAD_SHORT = False

    panel = JPanel()
    type_text = JLabel("Type: ")
    type_options = list(proximal_map.keys())
    proximal_type_box = JComboBox(type_options, actionListener=ProximalTypeListner())
    # Add suboptions:
    GS_box = JCheckBox("GS", GS, actionPerformed=proximal_options)
    GRAD_box = JCheckBox("GRAD", GRAD, actionPerformed=proximal_options)
    GRAD_SHORT_box = JCheckBox(
        "GRAD_SHORT", GRAD_SHORT, actionPerformed=proximal_options
    )
    # Define layout:
    layout = GroupLayout(panel)
    panel.setLayout(layout)
    # Vertical setup:
    vertical = layout.createSequentialGroup()
    type_group = layout.createParallelGroup(center)
    type_group.addComponent(type_text)
    type_group.addComponent(proximal_type_box)
    vertical.addGroup(type_group)
    vertical.addComponent(GS_box)
    vertical.addComponent(GRAD_box)
    vertical.addComponent(GRAD_SHORT_box)
    layout.setVerticalGroup(vertical)
    # Horizontal setup:
    horizontal = layout.createParallelGroup()
    type_group = layout.createSequentialGroup()
    type_group.addComponent(type_text)
    type_group.addComponent(proximal_type_box)
    horizontal.addGroup(type_group)
    horizontal.addComponent(GS_box)
    horizontal.addComponent(GRAD_box)
    horizontal.addComponent(GRAD_SHORT_box)
    layout.setHorizontalGroup(horizontal)
    return panel


def create_distal():
    """Create a panel for the distal dimension."""

    def distal_options(event):
        if DGS_box.isSelected():
            action_add_option("DGS")
        else:
            action_remove_option("DGS")
        if DGRAD_box.isSelected():
            action_add_option("DGRAD")
        else:
            action_remove_option("DGRAD")
        if DGRAD_SHORT_box.isSelected():
            action_add_option("DGRAD_SHORT")
        else:
            action_remove_option("DGRAD_SHORT")

    class DistalTypeListner(ActionListener):
        def actionPerformed(self, event):
            global distal_type
            new_distal_type = distal_type_box.getSelectedItem()
            if new_distal_type != distal_type:
                action_remove_option(distal_map[distal_type])
                action_add_option(distal_map[new_distal_type])
                distal_type = new_distal_type

    if "DGS" in options:
        DGS = True
    else:
        DGS = False
    if "DGRAD" in options:
        DGRAD = True
    else:
        DGRAD = False
    if "DGRAD_SHORT" in options:
        DGRAD_SHORT = True
    else:
        DGRAD_SHORT = False

    panel = JPanel()
    type_text = JLabel("Type: ")
    type_options = list(distal_map.keys())
    distal_type_box = JComboBox(type_options, actionListener=DistalTypeListner())
    # Add suboptions:
    DGS_box = JCheckBox("GS", DGS, actionPerformed=distal_options)
    DGRAD_box = JCheckBox("GRAD", DGRAD, actionPerformed=distal_options)
    DGRAD_SHORT_box = JCheckBox(
        "GRAD_SHORT", DGRAD_SHORT, actionPerformed=distal_options
    )
    # Define layout:
    layout = GroupLayout(panel)
    panel.setLayout(layout)
    # Vertical setup:
    vertical = layout.createSequentialGroup()
    # vertical.addComponent(text)
    type_group = layout.createParallelGroup(center)
    type_group.addComponent(type_text)
    type_group.addComponent(distal_type_box)
    vertical.addGroup(type_group)
    vertical.addComponent(DGS_box)
    vertical.addComponent(DGRAD_box)
    vertical.addComponent(DGRAD_SHORT_box)
    layout.setVerticalGroup(vertical)
    # Horizontal setup:
    horizontal = layout.createParallelGroup()
    # horizontal.addComponent(text)
    type_group = layout.createSequentialGroup()
    type_group.addComponent(type_text)
    type_group.addComponent(distal_type_box)
    horizontal.addGroup(type_group)
    horizontal.addComponent(DGS_box)
    horizontal.addComponent(DGRAD_box)
    horizontal.addComponent(DGRAD_SHORT_box)
    layout.setHorizontalGroup(horizontal)
    return panel


def create_start():
    """Create a panel with global settings for pulse sequences."""

    def start_options(event):
        if PRESAT_box.isSelected():
            action_add_option("PRESAT")
        else:
            action_remove_option("PRESAT")
        if CRUSH_box.isSelected():
            action_add_option("CRUSH")
        else:
            action_remove_option("CRUSH")
        if FB_box.isSelected():
            action_add_option("FB")
        else:
            action_remove_option("FB")

    panel = JPanel()
    # Add suboptions:
    PRESAT_box = JCheckBox("PRESAT", actionPerformed=start_options)
    CRUSH_box = JCheckBox("CRUSH", actionPerformed=start_options)
    FB_box = JCheckBox("FB", actionPerformed=start_options)
    layout = GroupLayout(panel)
    panel.setLayout(layout)
    
    # Vertical setup:
    vertical = layout.createSequentialGroup()
    filler_group = layout.createParallelGroup(center)
    filler_group.addComponent(PRESAT_box)
    filler_group.addComponent(FB_box)
    vertical.addGroup(filler_group)
    # vertical.addComponent(CRUSH_box)
    layout.setVerticalGroup(vertical)
    # # Horizontal setup:
    horizontal = layout.createParallelGroup(GroupLayout.Alignment.LEADING)
    filler_group = layout.createSequentialGroup()
    filler_group.addComponent(PRESAT_box)
    filler_group.addComponent(FB_box)
    horizontal.addGroup(filler_group)
    horizontal.addComponent(PRESAT_box)
    # horizontal.addComponent(CRUSH_box)
    layout.setHorizontalGroup(horizontal)
    # Alignment:
    PRESAT_box.setAlignmentX(Component.LEFT_ALIGNMENT)
    CRUSH_box.setAlignmentX(Component.LEFT_ALIGNMENT)
    FB_box.setAlignmentX(Component.LEFT_ALIGNMENT)
    return panel

# Arrange panels vertically:
frame = JFrame()

top_panel = JPanel()
top_panel.setLayout(BoxLayout(top_panel, BoxLayout.Y_AXIS))

top_panel.add(JLabel("Global settings"))
start = create_start()
top_panel.add(start)

top_panel.add(JLabel("Proximal 2D"))
proximal = create_proximal()
top_panel.add(proximal)

top_panel.add(JLabel("Distal 2D"))
distal = create_distal()
top_panel.add(distal)

frame.add(top_panel)

frame.pack()
frame.setVisible(True)
