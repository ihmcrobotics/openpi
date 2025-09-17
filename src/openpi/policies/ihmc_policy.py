import dataclasses

import einops
import numpy as np

from openpi import transforms
from openpi.models import model as _model


def make_ihmc_example() -> dict:
    """Creates a random input example for the IHMC policy."""
    return {
        "observation/state": np.random.rand(28),
        "observation/images": {
            "cam_zed_left": np.random.randint(256, size=(3, 224, 224), dtype=np.uint8),
            "cam_zed_right": np.random.randint(256, size=(3, 224, 224), dtype=np.uint8),
        },
        "prompt": "0 Touch handle.",
    }


def _parse_image(image) -> np.ndarray:
    image = np.asarray(image)
    if np.issubdtype(image.dtype, np.floating):
        image = (255 * image).astype(np.uint8)
    if image.shape[0] == 3:
        image = einops.rearrange(image, "c h w -> h w c")
    return image

@dataclasses.dataclass(frozen=True)
class IHMCInputs(transforms.DataTransformFn):
    """Inputs for the IHMC policy.

    Expected inputs:
    - images: dict[name, img] where img is [channel, height, width]. name must be in EXPECTED_CAMERAS.
    - state: [28]
    - actions: [action_horizon, 28]
    """

    model_type: _model.ModelType

    def __call__(self, data: dict) -> dict:

        zed_left_image = _parse_image(data["observation/images/cam_zed_left"])
        zed_right_image = _parse_image(data["observation/images/cam_zed_right"])

        # Create inputs dict. Do not change the keys in the dict below.
        inputs = {
            "state": data["observation/state"],
            "image": {
                "base_0_rgb": zed_left_image,
                "left_wrist_0_rgb": zed_right_image,
                # Pad non-existent images with zero-array of the appropriate shape.
                "right_wrist_0_rgb": np.zeros_like(zed_left_image),
            },
            "image_mask": {
                "base_0_rgb": np.True_,
                "left_wrist_0_rgb": np.True_,
                # We only mask padding images for pi0 model, not pi0-FAST. Do not change this for your own dataset.
                "right_wrist_0_rgb": np.True_ if self.model_type == _model.ModelType.PI0_FAST else np.False_,
            },
            "actions": data["action"],
            "prompt": data["prompt"]
        }

        return inputs


@dataclasses.dataclass(frozen=True)
class IHMCOutputs(transforms.DataTransformFn):
    """Outputs for the IHMC policy."""

    def __call__(self, data: dict) -> dict:
        # Only return the first 28 dims.
        return {"actions": np.asarray(data["actions"][:, :28])}
