
# VARIABLES #

# Define the path to an executable for downloading a remote resource:
DEPS_DOWNLOAD_BIN ?= $(TOOLS_DIR)/scripts/download

# Define the path to an executable for verifying a download:
DEPS_CHECKSUM_BIN ?= $(TOOLS_DIR)/scripts/checksum

# Define the download URL:
DEPS_OPENBLAS_URL ?= https://github.com/xianyi/OpenBLAS/archive/v$(DEPS_OPENBLAS_VERSION).tar.gz

# Determine the basename for the download:
deps_openblas_basename := openblas_$(deps_openblas_version_slug).tar.gz

# Define the path to the file containing a checksum to verify a download:
DEPS_OPENBLAS_CHECKSUM ?= $(shell cat $(DEPS_CHECKSUMS_DIR)/$(subst .,_,$(deps_openblas_basename))/sha256)

# Define the output path when downloading:
DEPS_OPENBLAS_DOWNLOAD_OUT ?= $(DEPS_TMP_DIR)/$(deps_openblas_basename)

# Define the output path after extracting:
deps_openblas_extract_out := $(DEPS_BUILD_DIR)/OpenBLAS-$(DEPS_OPENBLAS_VERSION)

# Define the path to the directory containing tests:
DEPS_OPENBLAS_TEST_DIR ?= $(DEPS_DIR)/test/openblas

# Define the output directory path for compiled tests:
DEPS_OPENBLAS_TEST_OUT ?= $(DEPS_OPENBLAS_TEST_DIR)/build

# Define the path to a test file for checking an installation:
DEPS_OPENBLAS_TEST_INSTALL ?= $(DEPS_OPENBLAS_TEST_DIR)/test_install.c

# Define the output path for a test file:
DEPS_OPENBLAS_TEST_INSTALL_OUT ?= $(DEPS_OPENBLAS_TEST_OUT)/test_install

# Define build options (originally based on Julia; see https://github.com/JuliaLang/julia/blob/master/deps/blas.mk):
DEPS_OPENBLAS_BUILD_OPTS := \
	CC="$(CC)" \
	FC="$(FC)" \
	RANLIB="$(RANLIB)" \
	CFLAGS="$(DEPS_OPENBLAS_CFLAGS)" \
	FFLAGS="$(DEPS_OPENBLAS_FFLAGS)" \
	TARGET="$(DEPS_OPENBLAS_TARGET_ARCH)" \
	BINARY="$(DEPS_OPENBLAS_BINARY)"

# Define threading options:
ifeq ($(DEPS_OPENBLAS_USE_THREAD), 1)
	DEPS_OPENBLAS_BUILD_OPTS += USE_THREAD=1

	# If any `gemm` argument `m`, `n` or `k` is less or equal a provided threshold, `gemm` will be execute using a single thread. This flag is used to avoid the overhead of multi-threading in small matrix sizes. The default value is 4.
	DEPS_OPENBLAS_BUILD_OPTS += GEMM_MULTITHREADING_THRESHOLD=50

# Determine the maximum number of threads (which should be less than the number of cores) for parallelism:
ifneq ($(DEPS_OPENBLAS_ARCH), x86_64)
	# 1) We assume that limited memory will restrict the number of threads we can spawn.
	# 2) 32-bit architectures are likely to have fewer cores.
	DEPS_OPENBLAS_BUILD_OPTS += NUM_THREADS=8
else
ifeq ($(OS), WINNT)
	# Windows does not seem capable of handling many threads:
	DEPS_OPENBLAS_BUILD_OPTS += NUM_THREADS=16
else
ifeq ($(OS), Darwin)
	# 16 threads should suffice for the largest Macs:
	DEPS_OPENBLAS_BUILD_OPTS += NUM_THREADS=16
else
	# For Linux, we try to account for (currently) the largest possible machine:
	DEPS_OPENBLAS_BUILD_OPTS += NUM_THREADS=16
endif # OS==Darwin
endif # OS==WINNT
endif # ARCH!=x86_64
else
	DEPS_OPENBLAS_BUILD_OPTS += USE_THREAD=0
endif

# Disable CPU/memory (scheduler) affinity on Linux:
DEPS_OPENBLAS_BUILD_OPTS += NO_AFFINITY=1

# Determine whether to build for multiple architectures in a single binary:
ifeq ($(DEPS_OPENBLAS_DYNAMIC_ARCH), 1)
	DEPS_OPENBLAS_BUILD_OPTS += DYNAMIC_ARCH=1
else
	DEPS_OPENBLAS_BUILD_OPTS += DYNAMIC_ARCH=0
endif

# Determine whether to compile a debug build:
ifeq ($(DEPS_OPENBLAS_DEBUG), 1)
	DEPS_OPENBLAS_BUILD_OPTS += DEBUG=1
endif

# Allow disabling AVX for older `binutils`:
ifeq ($(DEPS_OPENBLAS_NO_AVX), 1)
	DEPS_OPENBLAS_BUILD_OPTS += NO_AVX=1 NO_AVX2=1
else
ifeq ($(DEPS_OPENBLAS_NO_AVX2), 1)
	DEPS_OPENBLAS_BUILD_OPTS += NO_AVX2=1
endif
endif

# Determine whether to compile the CBLAS interface:
ifeq ($(DEPS_OPENBLAS_NO_CBLAS), 1)
	DEPS_OPENBLAS_BUILD_OPTS += NO_CBLAS=1
endif

# Determine whether to only compile the CBLAS interface:
ifeq ($(DEPS_OPENBLAS_ONLY_CBLAS), 1)
	DEPS_OPENBLAS_BUILD_OPTS += ONLY_CBLAS=1
endif

# Determine whether to compile LAPACK:
ifeq ($(DEPS_OPENBLAS_NO_LAPACK), 1)
	DEPS_OPENBLAS_BUILD_OPTS += NO_LAPACK=1
endif

# Determine whether to compile the C interface to LAPACK:
ifeq ($(DEPS_OPENBLAS_NO_LAPACKE), 1)
	DEPS_OPENBLAS_BUILD_OPTS += NO_LAPACKE=1
endif

# Determine whether to build a 64-bit BLAS interface:
ifeq ($(DEPS_OPENBLAS_USE_BLAS64), 1)
	DEPS_OPENBLAS_BUILD_OPTS += INTERFACE64=1 SYMBOLSUFFIX="$(DEPS_OPENBLAS_SYMBOLSUFFIX)" SYMBOLPREFIX="$(DEPS_OPENBLAS_SYMBOLPREFIX)"
endif

# Do not allow overwriting the `-j` flag which specifies the number of `make` jobs:
DEPS_OPENBLAS_BUILD_OPTS += MAKE_NB_JOBS=0


# TARGETS #

# Download.
#
# This target downloads a OpenBLAS distribution.

$(DEPS_OPENBLAS_DOWNLOAD_OUT): | $(DEPS_TMP_DIR)
	$(QUIET) echo 'Downloading OpenBLAS...' >&2
	$(QUIET) $(DEPS_DOWNLOAD_BIN) $(DEPS_OPENBLAS_URL) $(DEPS_OPENBLAS_DOWNLOAD_OUT)


# Extract.
#
# This target extracts a gzipped tar archive.

$(DEPS_OPENBLAS_BUILD_OUT): $(DEPS_OPENBLAS_DOWNLOAD_OUT) | $(DEPS_BUILD_DIR)
	$(QUIET) echo 'Extracting OpenBLAS...' >&2
	$(QUIET) $(TAR) -zxf $(DEPS_OPENBLAS_DOWNLOAD_OUT) -C $(DEPS_BUILD_DIR)
	$(QUIET) mv $(deps_openblas_extract_out) $(DEPS_OPENBLAS_BUILD_OUT)


# Create directory for tests.
#
# This target creates a directory for storing compiled tests.

$(DEPS_OPENBLAS_TEST_OUT):
	$(QUIET) $(MKDIR_RECURSIVE) $(DEPS_OPENBLAS_TEST_OUT)


# Compile install test.
#
# This target compiles a test file for testing an installation.

$(DEPS_OPENBLAS_TEST_INSTALL_OUT): $(DEPS_OPENBLAS_BUILD_OUT) $(DEPS_OPENBLAS_TEST_OUT)
	$(QUIET) $(CC) $(DEPS_OPENBLAS_TEST_INSTALL) -o $(DEPS_OPENBLAS_TEST_INSTALL_OUT) -I $(DEPS_OPENBLAS_BUILD_OUT) -L $(DEPS_OPENBLAS_BUILD_OUT) -lopenblas -lpthread


# Download OpenBLAS.
#
# This target downloads an OpenBLAS distribution.

deps-download-openblas: $(DEPS_OPENBLAS_DOWNLOAD_OUT)

.PHONY: deps-download-openblas


# Verify download.
#
# This targets verifies a download.

deps-verify-openblas: deps-download-openblas
	$(QUIET) echo 'Verifying download...' >&2
	$(QUIET) $(DEPS_CHECKSUM_BIN) $(DEPS_OPENBLAS_DOWNLOAD_OUT) $(DEPS_OPENBLAS_CHECKSUM) >&2

.PHONY: deps-verify-openblas


# Extract OpenBLAS.
#
# This target extracts an OpenBLAS download.

deps-extract-openblas: $(DEPS_OPENBLAS_BUILD_OUT)

.PHONY: deps-extract-openblas


# Install OpenBLAS.
#
# This target performs the OpenBLAS install sequence.

deps-install-openblas: $(DEPS_OPENBLAS_BUILD_OUT)
	$(QUIET) $(MAKE) --directory="$(DEPS_OPENBLAS_BUILD_OUT)" $(DEPS_OPENBLAS_BUILD_OPTS)

.PHONY: deps-install-openblas


# Test install.
#
# This target tests an installation.

deps-test-openblas: $(DEPS_OPENBLAS_TEST_INSTALL_OUT)
	$(QUIET) echo 'Running tests...' >&2
	$(QUIET) $(DEPS_OPENBLAS_TEST_INSTALL_OUT)
	$(QUIET) echo '' >&2
	$(QUIET) echo 'Success.' >&2

.PHONY: deps-test-openblas


# Install OpenBLAS.
#
# This target installs OpenBLAS.

install-deps-openblas: deps-download-openblas deps-verify-openblas deps-extract-openblas deps-install-openblas deps-test-openblas

.PHONY: install-deps-openblas


# Clean OpenBLAS.
#
# This target removes an OpenBLAS distribution (but does not remove an OpenBLAS download if one exists).

clean-deps-openblas: clean-deps-openblas-tests
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(DEPS_OPENBLAS_BUILD_OUT)

.PHONY: clean-deps-openblas


# Clean installation tests.
#
# This target remove installation tests.

clean-deps-openblas-tests:
	$(QUIET) $(DELETE) $(DELETE_FLAGS) $(DEPS_OPENBLAS_TEST_OUT)

.PHONY: clean-deps-openblas-tests
